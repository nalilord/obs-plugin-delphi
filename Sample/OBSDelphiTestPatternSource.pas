unit OBSDelphiTestPatternSource;

interface

uses
  System.SysUtils,
  System.Math,
  Winapi.Windows,
  XENOME.OBS,
  XENOME.OBS.Types,
  XENOME.OBS.Data,
  XENOME.OBS.Source,
  XENOME.OBS.Audio,
  XENOME.OBS.Properties;

procedure RegisterOBSDelphiTestPatternSource;

implementation

const
  TEST_SOURCE_ID: AnsiString = 'delphi_test_pattern_source';
  TEST_SOURCE_NAME: AnsiString = 'Delphi Test Pattern + Tone';
  SETTING_WIDTH: PAnsiChar = 'width';
  SETTING_HEIGHT: PAnsiChar = 'height';
  SETTING_FREQUENCY: PAnsiChar = 'frequency';
  DEFAULT_WIDTH = 640;
  DEFAULT_HEIGHT = 360;
  DEFAULT_FREQUENCY = 440.0;
  DEFAULT_SAMPLE_RATE = 48000;
  TWO_PI = Pi * 2.0;

type
  POBSTestPatternSource = ^TOBSTestPatternSource;
  TOBSTestPatternSource = record
    Source: POBSSource;
    Width: Cardinal;
    Height: Cardinal;
    Frequency: Double;
    Phase: Double;
    PendingAudioFrames: Double;
    NextVideoTimestamp: UInt64;
    NextAudioTimestamp: UInt64;
    FrameIndex: UInt64;
    Frame: TOBSSourceFrame;
    AudioLeft: array[0..AUDIO_OUTPUT_FRAMES - 1] of Single;
    AudioRight: array[0..AUDIO_OUTPUT_FRAMES - 1] of Single;
  end;

var
  TestSourceInfo: TOBSSourceInfo;

function ClampInt64(AValue, AMin, AMax: Int64): Cardinal;
begin
  if AValue < AMin then
    AValue:=AMin
  else if AValue > AMax then
    AValue:=AMax;

  Result:=Cardinal(AValue);
end;

function ClampDouble(AValue, AMin, AMax: Double): Double;
begin
  if AValue < AMin then
    Result:=AMin
  else if AValue > AMax then
    Result:=AMax
  else
    Result:=AValue;
end;

function CurrentTimestampNs: UInt64;
begin
  Result:=GetTickCount64 * 1000000;
end;

procedure FreeFrame(var AFrame: TOBSSourceFrame);
begin
  if AFrame.Data[0] <> nil then
    bfree(AFrame.Data[0]);

  FillChar(AFrame, SizeOf(AFrame), 0);
end;

procedure InitFrame(ASource: POBSTestPatternSource);
begin
  FreeFrame(ASource^.Frame);
  obs_source_frame_init(@ASource^.Frame, VIDEO_FORMAT_RGBA, ASource^.Width, ASource^.Height);
  ASource^.Frame.Format:=VIDEO_FORMAT_RGBA;
  ASource^.Frame.FullRange:=True;
end;

procedure LoadSettings(ASource: POBSTestPatternSource; ASettings: POBSData);
var
  NewWidth: Cardinal;
  NewHeight: Cardinal;
begin
  if ASettings = nil then
    Exit;

  NewWidth:=ClampInt64(obs_data_get_int(ASettings, SETTING_WIDTH), 64, 3840);
  NewHeight:=ClampInt64(obs_data_get_int(ASettings, SETTING_HEIGHT), 64, 2160);

  ASource^.Frequency:=ClampDouble(obs_data_get_double(ASettings, SETTING_FREQUENCY), 20.0, 2000.0);

  if (NewWidth <> ASource^.Width) or (NewHeight <> ASource^.Height) or (ASource^.Frame.Data[0] = nil) then
  begin
    ASource^.Width:=NewWidth;
    ASource^.Height:=NewHeight;
    InitFrame(ASource);
  end;
end;

procedure WritePixel(ARow: PByte; AX: Integer; AR, AG, AB: Byte);
var
  Pixel: PByte;
begin
  Pixel:=ARow + (AX * 4);
  Pixel[0]:=AR;
  Pixel[1]:=AG;
  Pixel[2]:=AB;
  Pixel[3]:=$FF;
end;

procedure RenderTestPattern(ASource: POBSTestPatternSource);
const
  TOP_BAR_COLORS: array[0..7, 0..2] of Byte = (
    ($FF, $FF, $FF),
    ($FF, $FF, $00),
    ($00, $FF, $FF),
    ($00, $FF, $00),
    ($FF, $00, $FF),
    ($FF, $00, $00),
    ($00, $00, $FF),
    ($10, $10, $10)
  );
var
  X: Integer;
  Y: Integer;
  Width: Integer;
  Height: Integer;
  TopHeight: Integer;
  MidHeight: Integer;
  MarkerX: Integer;
  MarkerY: Integer;
  Row: PByte;
  BarIndex: Integer;
  Gray: Byte;
  Checker: Byte;
  R: Byte;
  G: Byte;
  B: Byte;
begin
  Width:=Integer(ASource^.Width);
  Height:=Integer(ASource^.Height);
  TopHeight:=(Height * 2) div 3;
  MidHeight:=(Height * 5) div 6;
  MarkerX:=Integer((ASource^.FrameIndex * 4) mod UInt64(Width));
  MarkerY:=Integer((ASource^.FrameIndex * 2) mod UInt64(Height));

  for Y:=0 to Height - 1 do
  begin
    Row:=ASource^.Frame.Data[0] + (Y * Integer(ASource^.Frame.LineSize[0]));

    for X:=0 to Width - 1 do
    begin
      if Y < TopHeight then
      begin
        BarIndex:=(X * 8) div Width;
        R:=TOP_BAR_COLORS[BarIndex][0];
        G:=TOP_BAR_COLORS[BarIndex][1];
        B:=TOP_BAR_COLORS[BarIndex][2];
      end
      else if Y < MidHeight then
      begin
        Gray:=Byte((X * 255) div Max(1, Width - 1));
        R:=Gray;
        G:=Gray;
        B:=Gray;
      end
      else
      begin
        Checker:=Byte((((X div 16) xor (Y div 16)) and 1) * $40);
        R:=Byte((X * 255) div Max(1, Width - 1));
        G:=Byte((Y * 255) div Max(1, Height - 1));
        B:=Checker;
      end;

      if (X = MarkerX) or (Y = MarkerY) then
      begin
        R:=$FF;
        G:=$FF;
        B:=$FF;
      end;

      WritePixel(Row, X, R, G, B);
    end;
  end;
end;

procedure OutputAudio(ASource: POBSTestPatternSource; ASeconds: Single);
var
  SampleCount: Integer;
  ChunkSamples: Integer;
  I: Integer;
  Audio: TOBSSourceAudio;
  SampleValue: Single;
  PhaseStep: Double;
begin
  ASource^.PendingAudioFrames:=ASource^.PendingAudioFrames + (ASeconds * DEFAULT_SAMPLE_RATE);
  SampleCount:=Trunc(ASource^.PendingAudioFrames);

  if SampleCount <= 0 then
    Exit;

  ASource^.PendingAudioFrames:=ASource^.PendingAudioFrames - SampleCount;
  PhaseStep:=TWO_PI * ASource^.Frequency / DEFAULT_SAMPLE_RATE;

  while SampleCount > 0 do
  begin
    ChunkSamples:=Min(SampleCount, AUDIO_OUTPUT_FRAMES);

    for I:=0 to ChunkSamples - 1 do
    begin
      SampleValue:=Sin(ASource^.Phase) * 0.20;
      ASource^.AudioLeft[I]:=SampleValue;
      ASource^.AudioRight[I]:=SampleValue;
      ASource^.Phase:=ASource^.Phase + PhaseStep;

      if ASource^.Phase >= TWO_PI then
        ASource^.Phase:=ASource^.Phase - TWO_PI;
    end;

    FillChar(Audio, SizeOf(Audio), 0);
    Audio.Data[0]:=PByte(@ASource^.AudioLeft[0]);
    Audio.Data[1]:=PByte(@ASource^.AudioRight[0]);
    Audio.Frames:=Cardinal(ChunkSamples);
    Audio.Speakers:=SPEAKERS_STEREO;
    Audio.Format:=AUDIO_FORMAT_FLOAT_PLANAR;
    Audio.SamplesPerSec:=DEFAULT_SAMPLE_RATE;
    Audio.TimeStamp:=ASource^.NextAudioTimestamp;
    obs_source_output_audio(ASource^.Source, @Audio);

    ASource^.NextAudioTimestamp:=ASource^.NextAudioTimestamp +
      (UInt64(ChunkSamples) * 1000000000) div DEFAULT_SAMPLE_RATE;
    Dec(SampleCount, ChunkSamples);
  end;
end;

function TestSourceGetName(ATypeData: Pointer): PAnsiChar; cdecl;
begin
  Result:=PAnsiChar(TEST_SOURCE_NAME);
end;

function TestSourceCreate(ASettings: POBSData; ASource: POBSSource): Pointer; cdecl;
var
  SourceData: POBSTestPatternSource;
begin
  New(SourceData);
  FillChar(SourceData^, SizeOf(SourceData^), 0);

  SourceData^.Source:=ASource;
  SourceData^.Width:=DEFAULT_WIDTH;
  SourceData^.Height:=DEFAULT_HEIGHT;
  SourceData^.Frequency:=DEFAULT_FREQUENCY;
  SourceData^.NextVideoTimestamp:=CurrentTimestampNs;
  SourceData^.NextAudioTimestamp:=SourceData^.NextVideoTimestamp;
  InitFrame(SourceData);
  LoadSettings(SourceData, ASettings);

  Result:=SourceData;
end;

procedure TestSourceDestroy(AData: Pointer); cdecl;
var
  SourceData: POBSTestPatternSource;
begin
  SourceData:=POBSTestPatternSource(AData);
  if SourceData = nil then
    Exit;

  FreeFrame(SourceData^.Frame);
  Dispose(SourceData);
end;

function TestSourceGetWidth(AData: Pointer): Cardinal; cdecl;
begin
  Result:=POBSTestPatternSource(AData)^.Width;
end;

function TestSourceGetHeight(AData: Pointer): Cardinal; cdecl;
begin
  Result:=POBSTestPatternSource(AData)^.Height;
end;

procedure TestSourceGetDefaults(ASettings: POBSData); cdecl;
begin
  obs_data_set_default_int(ASettings, SETTING_WIDTH, DEFAULT_WIDTH);
  obs_data_set_default_int(ASettings, SETTING_HEIGHT, DEFAULT_HEIGHT);
  obs_data_set_default_double(ASettings, SETTING_FREQUENCY, DEFAULT_FREQUENCY);
end;

function TestSourceGetProperties(AData: Pointer): POBSProperties; cdecl;
begin
  Result:=obs_properties_create;
  obs_properties_add_int(Result, SETTING_WIDTH, 'Width', 64, 3840, 2);
  obs_properties_add_int(Result, SETTING_HEIGHT, 'Height', 64, 2160, 2);
  obs_properties_add_float(Result, SETTING_FREQUENCY, 'Tone Frequency (Hz)', 20.0, 2000.0, 1.0);
end;

procedure TestSourceUpdate(AData: Pointer; ASettings: POBSData); cdecl;
begin
  LoadSettings(POBSTestPatternSource(AData), ASettings);
end;

procedure TestSourceVideoTick(AData: Pointer; ASeconds: Single); cdecl;
var
  SourceData: POBSTestPatternSource;
begin
  SourceData:=POBSTestPatternSource(AData);
  if SourceData = nil then
    Exit;

  if SourceData^.Frame.Data[0] = nil then
    InitFrame(SourceData);

  RenderTestPattern(SourceData);
  SourceData^.Frame.TimeStamp:=SourceData^.NextVideoTimestamp;
  obs_source_output_video(SourceData^.Source, @SourceData^.Frame);

  SourceData^.NextVideoTimestamp:=SourceData^.NextVideoTimestamp + UInt64(Round(ASeconds * 1000000000.0));
  Inc(SourceData^.FrameIndex);
  OutputAudio(SourceData, ASeconds);
end;

procedure RegisterOBSDelphiTestPatternSource;
begin
  FillChar(TestSourceInfo, SizeOf(TestSourceInfo), 0);
  TestSourceInfo.Id:=PAnsiChar(TEST_SOURCE_ID);
  TestSourceInfo.Typ:=OBS_SOURCE_TYPE_INPUT;
  TestSourceInfo.OutputFlags:=OBS_SOURCE_ASYNC_VIDEO or OBS_SOURCE_AUDIO;
  TestSourceInfo.GetName:=@TestSourceGetName;
  TestSourceInfo.Create:=@TestSourceCreate;
  TestSourceInfo.Destroy:=@TestSourceDestroy;
  TestSourceInfo.GetWidth:=@TestSourceGetWidth;
  TestSourceInfo.GetHeight:=@TestSourceGetHeight;
  TestSourceInfo.GetDefaults:=@TestSourceGetDefaults;
  TestSourceInfo.GetProperties:=@TestSourceGetProperties;
  TestSourceInfo.Update:=@TestSourceUpdate;
  TestSourceInfo.VideoTick:=@TestSourceVideoTick;
  TestSourceInfo.IconType:=OBS_ICON_TYPE_CUSTOM;
  TestSourceInfo.Version:=1;
  obs_register_source_s(@TestSourceInfo, SizeOf(TestSourceInfo));
end;

end.
