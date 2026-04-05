library OBSDelphiFrontendSmokePlugin;

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

var
  Module: POBSModule;
  RegisteredGlobalSignalHandler: POBSSignalHandler;
  QueuedTaskCount: Integer;

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

function EnumSourcesCount(AParam: Pointer; ASource: POBSSource): Boolean; cdecl;
begin
  PInteger(AParam)^:=PInteger(AParam)^ + 1;
  Result:=True;
end;

function EnumOutputsCount(AParam: Pointer; AOutput: POBSOutput): Boolean; cdecl;
begin
  PInteger(AParam)^:=PInteger(AParam)^ + 1;
  Result:=True;
end;

procedure UITaskCallback(AParam: Pointer); cdecl;
begin
  Inc(QueuedTaskCount);
  LogLine('ui_task: executed #' + AnsiString(IntToStr(QueuedTaskCount)));
end;

procedure OBSGlobalSignal(APrivateData: Pointer; ASignal: PAnsiChar; AParams: POBSCallData); cdecl;
var
  Source: POBSSource;
  PrevName: AnsiString;
  NewName: AnsiString;
begin
  if not ((SafeAnsi(ASignal) = 'source_create') or
          (SafeAnsi(ASignal) = 'source_destroy') or
          (SafeAnsi(ASignal) = 'source_rename')) then
    Exit;

  Source:=POBSSource(calldata_ptr(AParams, 'source'));

  if SafeAnsi(ASignal) = 'source_rename' then
  begin
    PrevName:=SafeAnsi(calldata_string(AParams, 'prev_name'));
    NewName:=SafeAnsi(calldata_string(AParams, 'new_name'));
    LogLine('signal: source_rename id=' + SafeAnsi(obs_source_get_id(Source)) +
      ' prev=' + PrevName + ' new=' + NewName);
  end
  else
  begin
    LogLine('signal: ' + SafeAnsi(ASignal) + ' id=' + SafeAnsi(obs_source_get_id(Source)) +
      ' name=' + SafeAnsi(obs_source_get_name(Source)));
  end;
end;

procedure SmokeToolsMenu(APrivateData: Pointer); cdecl;
var
  CurrentScene: POBSSource;
  CurrentProfile: PAnsiChar;
  CurrentCollection: PAnsiChar;
  SourceCount: Integer;
  OutputCount: Integer;
begin
  SourceCount:=0;
  OutputCount:=0;
  CurrentScene:=obs_frontend_get_current_scene;
  CurrentProfile:=obs_frontend_get_current_profile;
  CurrentCollection:=obs_frontend_get_current_scene_collection;
  try
    obs_enum_sources(@EnumSourcesCount, @SourceCount);
    obs_enum_outputs(@EnumOutputsCount, @OutputCount);

    LogLine('frontend_smoke: menu click');
    LogLine('frontend_smoke: current_scene=' + SafeAnsi(obs_source_get_name(CurrentScene)));
    LogLine('frontend_smoke: current_profile=' + SafeAnsi(CurrentProfile));
    LogLine('frontend_smoke: current_collection=' + SafeAnsi(CurrentCollection));
    LogLine('frontend_smoke: source_count=' + AnsiString(IntToStr(SourceCount)));
    LogLine('frontend_smoke: output_count=' + AnsiString(IntToStr(OutputCount)));

    obs_queue_task(OBS_TASK_UI, @UITaskCallback, nil, False);
  finally
    if CurrentScene <> nil then
      obs_source_release(CurrentScene);
    if CurrentProfile <> nil then
      obs_frontend_string_free(CurrentProfile);
    if CurrentCollection <> nil then
      obs_frontend_string_free(CurrentCollection);
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
  RegisteredGlobalSignalHandler:=obs_get_signal_handler;
  signal_handler_connect_global(RegisteredGlobalSignalHandler, @OBSGlobalSignal, nil);
  obs_frontend_add_tools_menu_item('Delphi Frontend Smoke', @SmokeToolsMenu, nil);
  LogLine('frontend_smoke: loaded');
  Result:=True;
end;

procedure obs_module_unload; cdecl;
begin
  if RegisteredGlobalSignalHandler <> nil then
    signal_handler_disconnect_global(RegisteredGlobalSignalHandler, @OBSGlobalSignal, nil);
end;

function obs_module_author: PAnsiChar; cdecl;
begin
  Result:='NaliLord';
end;

function obs_module_name: PAnsiChar; cdecl;
begin
  Result:='OBS Delphi Frontend Smoke';
end;

function obs_module_description: PAnsiChar; cdecl;
begin
  Result:='Frontend, signal, enumeration, and task smoke test for the Delphi OBS bindings.';
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
