library OBSDelphiOutputPacketSmokePlugin;

uses
  System.SysUtils,
  System.Generics.Collections,
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

type
  TTrackedOutputList = TList<POBSWeakOutput>;

var
  Module: POBSModule;
  TrackedOutputs: TTrackedOutputList;

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

function FindTrackedOutput(AOutput: POBSOutput): Integer;
var
  I: Integer;
begin
  Result:=-1;
  if AOutput = nil then
    Exit;

  for I:=0 to TrackedOutputs.Count - 1 do
    if obs_weak_output_references_output(TrackedOutputs[I], AOutput) then
      Exit(I);
end;

procedure PacketCallback(AOutput: POBSOutput; APacket: POBSEncoderPacket;
  APacketTime: POBSEncoderPacketTime; AParam: Pointer); cdecl;
var
  Line: AnsiString;
begin
  if (AOutput = nil) or (APacket = nil) then
    Exit;

  Line:='packet: output=' + SafeAnsi(obs_output_get_name(AOutput)) +
    ' id=' + SafeAnsi(obs_output_get_id(AOutput)) +
    ' size=' + AnsiString(IntToStr(APacket^.Size)) +
    ' pts=' + AnsiString(IntToStr(APacket^.PTS)) +
    ' dts=' + AnsiString(IntToStr(APacket^.DTS)) +
    ' keyframe=' + AnsiString(BoolToStr(APacket^.KeyFrame, True)) +
    ' track=' + AnsiString(IntToStr(APacket^.TrackIdx));

  if APacketTime <> nil then
    Line:=Line +
      ' cts=' + AnsiString(UIntToStr(APacketTime^.CTS)) +
      ' pir=' + AnsiString(UIntToStr(APacketTime^.PIR));

  LogLine(Line);
end;

function ReconnectCallback(AData: Pointer; AOutput: POBSOutput; ACode: Integer): Boolean; cdecl;
begin
  LogLine('reconnect: output=' + SafeAnsi(obs_output_get_name(AOutput)) +
    ' id=' + SafeAnsi(obs_output_get_id(AOutput)) +
    ' code=' + AnsiString(IntToStr(ACode)));
  Result:=True;
end;

procedure DetachOutputCallbacks(AOutput: POBSOutput);
begin
  if AOutput = nil then
    Exit;

  obs_output_remove_packet_callback(AOutput, @PacketCallback, nil);
  obs_output_set_reconnect_callback(AOutput, nil, nil);
end;

procedure LogOutputDetails(AOutput: POBSOutput);
var
  Service: POBSService;
  VideoEncoder: POBSEncoder;
  AudioEncoder: POBSEncoder;
begin
  if AOutput = nil then
    Exit;

  Service:=obs_output_get_service(AOutput);
  VideoEncoder:=obs_output_get_video_encoder(AOutput);
  AudioEncoder:=obs_output_get_audio_encoder(AOutput, 0);

  LogLine('output_smoke: output=' + SafeAnsi(obs_output_get_name(AOutput)) +
    ' id=' + SafeAnsi(obs_output_get_id(AOutput)) +
    ' active=' + AnsiString(BoolToStr(obs_output_active(AOutput), True)) +
    ' reconnecting=' + AnsiString(BoolToStr(obs_output_reconnecting(AOutput), True)) +
    ' flags=' + AnsiString(IntToStr(obs_output_get_flags(AOutput))));

  if Service <> nil then
    LogLine('output_smoke: service=' + SafeAnsi(obs_service_get_name(Service)) +
      ' id=' + SafeAnsi(obs_service_get_id(Service)) +
      ' type=' + SafeAnsi(obs_service_get_type(Service)));

  if VideoEncoder <> nil then
    LogLine('output_smoke: video_encoder=' + SafeAnsi(obs_encoder_get_name(VideoEncoder)) +
      ' id=' + SafeAnsi(obs_encoder_get_id(VideoEncoder)) +
      ' codec=' + SafeAnsi(obs_encoder_get_codec(VideoEncoder)));

  if AudioEncoder <> nil then
    LogLine('output_smoke: audio_encoder=' + SafeAnsi(obs_encoder_get_name(AudioEncoder)) +
      ' id=' + SafeAnsi(obs_encoder_get_id(AudioEncoder)) +
      ' codec=' + SafeAnsi(obs_encoder_get_codec(AudioEncoder)));
end;

function AttachOutputCallbacksEnum(AParam: Pointer; AOutput: POBSOutput): Boolean; cdecl;
var
  WeakOutput: POBSWeakOutput;
begin
  if FindTrackedOutput(AOutput) >= 0 then
  begin
    LogOutputDetails(AOutput);
    Exit(True);
  end;

  WeakOutput:=obs_output_get_weak_output(AOutput);
  if WeakOutput = nil then
    Exit(True);

  TrackedOutputs.Add(WeakOutput);
  obs_output_add_packet_callback(AOutput, @PacketCallback, nil);
  obs_output_set_reconnect_callback(AOutput, @ReconnectCallback, nil);
  LogOutputDetails(AOutput);
  Result:=True;
end;

procedure AttachOutputCallbacks;
begin
  obs_enum_outputs(@AttachOutputCallbacksEnum, nil);
  LogLine('output_smoke: tracked_outputs=' + AnsiString(IntToStr(TrackedOutputs.Count)));
end;

procedure DetachAllOutputCallbacks;
var
  I: Integer;
  Output: POBSOutput;
begin
  for I:=0 to TrackedOutputs.Count - 1 do
  begin
    Output:=obs_weak_output_get_output(TrackedOutputs[I]);
    try
      if Output <> nil then
        DetachOutputCallbacks(Output);
    finally
      if Output <> nil then
        obs_output_release(Output);
      obs_weak_output_release(TrackedOutputs[I]);
    end;
  end;

  TrackedOutputs.Clear;
end;

procedure OutputSmokeToolsMenu(APrivateData: Pointer); cdecl;
begin
  LogLine('output_smoke: menu click');
  AttachOutputCallbacks;
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
  TrackedOutputs:=TTrackedOutputList.Create;
  obs_frontend_add_tools_menu_item('Delphi Output Packet Smoke', @OutputSmokeToolsMenu, nil);
  LogLine('output_smoke: loaded');
  Result:=True;
end;

procedure obs_module_unload; cdecl;
begin
  if TrackedOutputs <> nil then
  begin
    DetachAllOutputCallbacks;
    TrackedOutputs.Free;
    TrackedOutputs:=nil;
  end;
end;

function obs_module_author: PAnsiChar; cdecl;
begin
  Result:='NaliLord';
end;

function obs_module_name: PAnsiChar; cdecl;
begin
  Result:='OBS Delphi Output Packet Smoke';
end;

function obs_module_description: PAnsiChar; cdecl;
begin
  Result:='Output, encoder, service, packet, and reconnect smoke test for the Delphi OBS bindings.';
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
