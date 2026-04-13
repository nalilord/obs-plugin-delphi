library OBSDelphiRegistrationSmokePlugin;

uses
  System.SysUtils,
  Winapi.Windows,
  XENOME.OBS in '..\Source\XENOME.OBS.pas',
  XENOME.OBS.Video in '..\Source\XENOME.OBS.Video.pas',
  XENOME.OBS.Frontend in '..\Source\XENOME.OBS.Frontend.pas',
  XENOME.OBS.Source in '..\Source\XENOME.OBS.Source.pas',
  XENOME.OBS.Audio in '..\Source\XENOME.OBS.Audio.pas',
  XENOME.OBS.Data in '..\Source\XENOME.OBS.Data.pas',
  XENOME.OBS.Types in '..\Source\XENOME.OBS.Types.pas',
  XENOME.OBS.Math in '..\Source\XENOME.OBS.Math.pas',
  XENOME.OBS.Graphics in '..\Source\XENOME.OBS.Graphics.pas',
  XENOME.OBS.Properties in '..\Source\XENOME.OBS.Properties.pas',
  XENOME.OBS.Misc in '..\Source\XENOME.OBS.Misc.pas',
  XENOME.OBS.VideoScaler in '..\Source\XENOME.OBS.VideoScaler.pas';

const
  DUMMY_SERVICE_ID: PAnsiChar = 'delphi_dummy_service_v1';
  DUMMY_OUTPUT_ID: PAnsiChar = 'delphi_dummy_output_v1';
  DUMMY_AUDIO_ENCODER_ID: PAnsiChar = 'delphi_dummy_audio_encoder_v1';

type
  PDummyServiceData = ^TDummyServiceData;
  TDummyServiceData = record
    Service: POBSService;
  end;

  PDummyOutputData = ^TDummyOutputData;
  TDummyOutputData = record
    Output: POBSOutput;
  end;

  PDummyEncoderData = ^TDummyEncoderData;
  TDummyEncoderData = record
    Encoder: POBSEncoder;
  end;

var
  Module: POBSModule;
  DummyServiceInfo: TOBSServiceInfo;
  DummyOutputInfo: TOBSOutputInfo;
  DummyEncoderInfo: TOBSEncoderInfo;
  DummyVideoCodecs: array[0..1] of PAnsiChar = ('dummyv', nil);
  DummyAudioCodecs: array[0..1] of PAnsiChar = ('dummya', nil);
  DummyResolutions: array[0..1] of TOBSServiceResolution = (
    (CX: 1280; CY: 720),
    (CX: 1920; CY: 1080)
  );

procedure LogLine(const AText: AnsiString);
begin
  WriteLn(String(AText));
end;

function SafeAnsi(AValue: PAnsiChar): AnsiString;
begin
  if AValue <> nil then
    Result:=AnsiString(AValue)
  else
    Result:='<nil>';
end;

function SafeJoinedStringList(AList: PPAnsiChar): AnsiString;
begin
  Result:=obs_string_list_join(AList);
  if Result = '' then
    Result:='<nil>';
end;

function DummyServiceGetName(ATypeData: Pointer): PAnsiChar; cdecl;
begin
  Result:='Delphi Dummy Service';
end;

function DummyServiceCreate(ASettings: POBSData; AService: POBSService): Pointer; cdecl;
var
  Data: PDummyServiceData;
begin
  New(Data);
  Data^.Service:=AService;
  LogLine('registration_smoke: service create');
  Result:=Data;
end;

procedure DummyServiceDestroy(AData: Pointer); cdecl;
begin
  LogLine('registration_smoke: service destroy');
  Dispose(PDummyServiceData(AData));
end;

function DummyServiceInitialize(AData: Pointer; AOutput: POBSOutput): Boolean; cdecl;
begin
  LogLine('registration_smoke: service initialize output=' + SafeAnsi(obs_output_get_name(AOutput)));
  Result:=True;
end;

function DummyServiceGetURL(AData: Pointer): PAnsiChar; cdecl;
begin
  Result:='https://example.invalid/live';
end;

function DummyServiceGetKey(AData: Pointer): PAnsiChar; cdecl;
begin
  Result:='dummy-key';
end;

function DummyServiceGetProtocol(AData: Pointer): PAnsiChar; cdecl;
begin
  Result:='dummy';
end;

function DummyServiceGetOutputType(AData: Pointer): PAnsiChar; cdecl;
begin
  Result:=DUMMY_OUTPUT_ID;
end;

function DummyServiceCanTryToConnect(AData: Pointer): Boolean; cdecl;
begin
  Result:=False;
end;

procedure DummyServiceGetSupportedResolutions(AData: Pointer; out Resolutions: POBSServiceResolution;
  out Count: NativeUInt); cdecl;
var
  Bytes: NativeUInt;
begin
  Count:=Length(DummyResolutions);
  Bytes:=Count * SizeOf(TOBSServiceResolution);
  Resolutions:=POBSServiceResolution(bmalloc(Bytes));
  if Resolutions <> nil then
    Move(DummyResolutions[0], Resolutions^, Bytes)
  else
    Count:=0;
end;

procedure DummyServiceGetMaxFPS(AData: Pointer; FPS: PInteger); cdecl;
begin
  if FPS <> nil then
    FPS^:=60;
end;

procedure DummyServiceGetMaxBitrate(AData: Pointer; VideoBitrate, AudioBitrate: PInteger); cdecl;
begin
  if VideoBitrate <> nil then
    VideoBitrate^:=6000;
  if AudioBitrate <> nil then
    AudioBitrate^:=320;
end;

function DummyServiceGetSupportedVideoCodecs(AData: Pointer): PPAnsiChar; cdecl;
begin
  Result:=@DummyVideoCodecs[0];
end;

function DummyServiceGetSupportedAudioCodecs(AData: Pointer): PPAnsiChar; cdecl;
begin
  Result:=@DummyAudioCodecs[0];
end;

function DummyServiceGetConnectInfo(AData: Pointer; InfoType: Cardinal): PAnsiChar; cdecl;
begin
  case InfoType of
    OBS_SERVICE_CONNECT_INFO_SERVER_URL: Result:='https://example.invalid/live';
    OBS_SERVICE_CONNECT_INFO_STREAM_ID: Result:='dummy-stream-id';
    OBS_SERVICE_CONNECT_INFO_USERNAME: Result:='dummy-user';
    OBS_SERVICE_CONNECT_INFO_PASSWORD: Result:='dummy-password';
    OBS_SERVICE_CONNECT_INFO_BEARER_TOKEN: Result:='dummy-token';
  else
    Result:=nil;
  end;
end;

function DummyOutputGetName(ATypeData: Pointer): PAnsiChar; cdecl;
begin
  Result:='Delphi Dummy Output';
end;

function DummyOutputCreate(ASettings: POBSData; AOutput: POBSOutput): Pointer; cdecl;
var
  Data: PDummyOutputData;
begin
  New(Data);
  Data^.Output:=AOutput;
  LogLine('registration_smoke: output create');
  Result:=Data;
end;

procedure DummyOutputDestroy(AData: Pointer); cdecl;
begin
  LogLine('registration_smoke: output destroy');
  Dispose(PDummyOutputData(AData));
end;

function DummyOutputStart(AData: Pointer): Boolean; cdecl;
begin
  LogLine('registration_smoke: output start');
  Result:=False;
end;

procedure DummyOutputStop(AData: Pointer; ATS: UInt64); cdecl;
begin
  LogLine('registration_smoke: output stop ts=' + AnsiString(UIntToStr(ATS)));
end;

procedure DummyOutputEncodedPacket(AData: Pointer; APacket: POBSEncoderPacket); cdecl;
begin
end;

function DummyEncoderGetName(ATypeData: Pointer): PAnsiChar; cdecl;
begin
  Result:='Delphi Dummy Audio Encoder';
end;

function DummyEncoderCreate(ASettings: POBSData; AEncoder: POBSEncoder): Pointer; cdecl;
var
  Data: PDummyEncoderData;
begin
  New(Data);
  Data^.Encoder:=AEncoder;
  LogLine('registration_smoke: encoder create');
  Result:=Data;
end;

procedure DummyEncoderDestroy(AData: Pointer); cdecl;
begin
  LogLine('registration_smoke: encoder destroy');
  Dispose(PDummyEncoderData(AData));
end;

function DummyEncoderEncode(AData: Pointer; AFrame: POBSEncoderFrame; APacket: POBSEncoderPacket;
  AReceivedPacket: PBoolean): Boolean; cdecl;
begin
  if AReceivedPacket <> nil then
    AReceivedPacket^:=False;
  Result:=True;
end;

function DummyEncoderGetFrameSize(AData: Pointer): NativeUInt; cdecl;
begin
  Result:=1024;
end;

procedure RegisterDummyComponents;
begin
  FillChar(DummyServiceInfo, SizeOf(DummyServiceInfo), 0);
  DummyServiceInfo.Id:=DUMMY_SERVICE_ID;
  DummyServiceInfo.GetName:=@DummyServiceGetName;
  DummyServiceInfo.Create:=@DummyServiceCreate;
  DummyServiceInfo.Destroy:=@DummyServiceDestroy;
  DummyServiceInfo.Initialize:=@DummyServiceInitialize;
  DummyServiceInfo.GetURL:=@DummyServiceGetURL;
  DummyServiceInfo.GetKey:=@DummyServiceGetKey;
  DummyServiceInfo.GetProtocol:=@DummyServiceGetProtocol;
  DummyServiceInfo.GetOutputType:=@DummyServiceGetOutputType;
  DummyServiceInfo.GetSupportedResolutions:=@DummyServiceGetSupportedResolutions;
  DummyServiceInfo.GetMaxFPS:=@DummyServiceGetMaxFPS;
  DummyServiceInfo.GetMaxBitrate:=@DummyServiceGetMaxBitrate;
  DummyServiceInfo.GetSupportedVideoCodecs:=@DummyServiceGetSupportedVideoCodecs;
  DummyServiceInfo.GetSupportedAudioCodecs:=@DummyServiceGetSupportedAudioCodecs;
  DummyServiceInfo.GetConnectInfo:=@DummyServiceGetConnectInfo;
  DummyServiceInfo.CanTryToConnect:=@DummyServiceCanTryToConnect;
  obs_register_service(@DummyServiceInfo);

  FillChar(DummyOutputInfo, SizeOf(DummyOutputInfo), 0);
  DummyOutputInfo.Id:=DUMMY_OUTPUT_ID;
  DummyOutputInfo.Flags:=OBS_OUTPUT_ENCODED or OBS_OUTPUT_SERVICE;
  DummyOutputInfo.GetName:=@DummyOutputGetName;
  DummyOutputInfo.Create:=@DummyOutputCreate;
  DummyOutputInfo.Destroy:=@DummyOutputDestroy;
  DummyOutputInfo.Start:=@DummyOutputStart;
  DummyOutputInfo.Stop:=@DummyOutputStop;
  DummyOutputInfo.EncodedPacket:=@DummyOutputEncodedPacket;
  DummyOutputInfo.EncodedVideoCodecs:='dummyv';
  DummyOutputInfo.EncodedAudioCodecs:='dummya';
  DummyOutputInfo.Protocols:='dummy';
  obs_register_output(@DummyOutputInfo);

  FillChar(DummyEncoderInfo, SizeOf(DummyEncoderInfo), 0);
  DummyEncoderInfo.Id:=DUMMY_AUDIO_ENCODER_ID;
  DummyEncoderInfo.Typ:=OBS_ENCODER_AUDIO;
  DummyEncoderInfo.Codec:='dummy_audio';
  DummyEncoderInfo.GetName:=@DummyEncoderGetName;
  DummyEncoderInfo.Create:=@DummyEncoderCreate;
  DummyEncoderInfo.Destroy:=@DummyEncoderDestroy;
  DummyEncoderInfo.Encode:=@DummyEncoderEncode;
  DummyEncoderInfo.GetFrameSize:=@DummyEncoderGetFrameSize;
  obs_register_encoder(@DummyEncoderInfo);
end;

procedure RegistrationSmokeToolsMenu(APrivateData: Pointer); cdecl;
var
  Service: POBSService;
  Output: POBSOutput;
  Encoder: POBSEncoder;
  Resolutions: POBSServiceResolution;
  ResolutionCount: NativeUInt;
  MaxFPS: Integer;
  MaxVideoBitrate: Integer;
  MaxAudioBitrate: Integer;
  ExtraData: PByte;
  ExtraDataSize: NativeUInt;
begin
  LogLine('registration_smoke: menu click');

  Service:=obs_service_create_private(DUMMY_SERVICE_ID, 'Delphi Dummy Service Instance', nil);
  try
    LogLine('registration_smoke: service instance=' + AnsiString(BoolToStr(Service <> nil, True)));
    if Service <> nil then
    begin
      LogLine('registration_smoke: service type=' + SafeAnsi(obs_service_get_id(Service)));
      LogLine('registration_smoke: service protocol=' + SafeAnsi(obs_service_get_protocol(Service)));
      LogLine('registration_smoke: service preferred_output=' + SafeAnsi(obs_service_get_preferred_output_type(Service)));
      LogLine('registration_smoke: service stream_url=' +
        SafeAnsi(obs_service_get_connect_info(Service, OBS_SERVICE_CONNECT_INFO_SERVER_URL)));
      LogLine('registration_smoke: service stream_key=' +
        SafeAnsi(obs_service_get_connect_info(Service, OBS_SERVICE_CONNECT_INFO_STREAM_KEY)));
      LogLine('registration_smoke: service can_try_connect=' +
        AnsiString(BoolToStr(obs_service_can_try_to_connect(Service), True)));
      LogLine('registration_smoke: service video_codec=' +
        SafeJoinedStringList(obs_service_get_supported_video_codecs(Service)));
      LogLine('registration_smoke: service audio_codec=' +
        SafeJoinedStringList(obs_service_get_supported_audio_codecs(Service)));
      Resolutions:=nil;
      ResolutionCount:=0;
      obs_service_get_supported_resolutions(Service, Resolutions, ResolutionCount);
      LogLine('registration_smoke: service resolutions=' + AnsiString(UIntToStr(ResolutionCount)));
      obs_service_resolution_list_free(Resolutions);
      MaxFPS:=0;
      obs_service_get_max_fps(Service, @MaxFPS);
      LogLine('registration_smoke: service max_fps=' + AnsiString(IntToStr(MaxFPS)));
      MaxVideoBitrate:=0;
      MaxAudioBitrate:=0;
      obs_service_get_max_bitrate(Service, @MaxVideoBitrate, @MaxAudioBitrate);
      LogLine('registration_smoke: service max_bitrate=' + AnsiString(IntToStr(MaxVideoBitrate)) +
        '/' + AnsiString(IntToStr(MaxAudioBitrate)));
      obs_service_apply_encoder_settings(Service, nil, nil);
    end;
  finally
    if Service <> nil then
      obs_service_release(Service);
  end;

  Output:=obs_output_create(DUMMY_OUTPUT_ID, 'Delphi Dummy Output Instance', nil, nil);
  try
    LogLine('registration_smoke: output instance=' + AnsiString(BoolToStr(Output <> nil, True)));
    if Output <> nil then
      LogLine('registration_smoke: output type=' + SafeAnsi(obs_output_get_id(Output)));
  finally
    if Output <> nil then
      obs_output_release(Output);
  end;

  Encoder:=obs_audio_encoder_create(DUMMY_AUDIO_ENCODER_ID, 'Delphi Dummy Audio Encoder Instance', nil, 0, nil);
  try
    LogLine('registration_smoke: encoder instance=' + AnsiString(BoolToStr(Encoder <> nil, True)));
    if Encoder <> nil then
    begin
      LogLine('registration_smoke: encoder type=' + SafeAnsi(obs_encoder_get_id(Encoder)) +
        ' codec=' + SafeAnsi(obs_encoder_get_codec(Encoder)));
      ExtraData:=nil;
      ExtraDataSize:=0;
      LogLine('registration_smoke: encoder extra_data=' +
        AnsiString(BoolToStr(obs_encoder_get_extra_data(Encoder, @ExtraData, @ExtraDataSize), True)) +
        ' size=' + AnsiString(UIntToStr(ExtraDataSize)));
    end;
  finally
    if Encoder <> nil then
      obs_encoder_release(Encoder);
  end;
end;

procedure obs_module_set_pointer(AModule: POBSModule); cdecl;
begin
  Module:=AModule;
end;

function obs_current_module: POBSModule; cdecl;
begin
  Result:=Module;
end;

function obs_module_ver: Cardinal;
begin
  Result:=LIBOBS_API_VER;
end;

function obs_module_load: Boolean; cdecl;
begin
  RegisterDummyComponents;
  obs_frontend_add_tools_menu_item('Delphi Registration Smoke', @RegistrationSmokeToolsMenu, nil);
  LogLine('registration_smoke: loaded');
  Result:=True;
end;

procedure obs_module_unload; cdecl;
begin
end;

function obs_module_author: PAnsiChar; cdecl;
begin
  Result:='NaliLord';
end;

function obs_module_name: PAnsiChar; cdecl;
begin
  Result:='OBS Delphi Registration Smoke';
end;

function obs_module_description: PAnsiChar; cdecl;
begin
  Result:='Encoder, service, and output registration smoke test for the Delphi OBS bindings.';
end;

exports
  obs_module_set_pointer,
  obs_current_module,
  obs_module_ver,
  obs_module_load,
  obs_module_unload,
  obs_module_author,
  obs_module_name,
  obs_module_description;

begin
  AllocConsole;
end.
