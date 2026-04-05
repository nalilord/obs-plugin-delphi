library OBSStatsExport;

uses
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  XENOME.OBS in 'XENOME.OBS.pas',
  XENOME.OBS.Video in 'XENOME.OBS.Video.pas',
  XENOME.OBS.Frontend in 'XENOME.OBS.Frontend.pas',
  XENOME.OBS.Source in 'XENOME.OBS.Source.pas',
  XENOME.OBS.Audio in 'XENOME.OBS.Audio.pas',
  XENOME.OBS.Data in 'XENOME.OBS.Data.pas',
  XENOME.OBS.Types in 'XENOME.OBS.Types.pas',
  XENOME.OBS.Math in 'XENOME.OBS.Math.pas',
  XENOME.OBS.Graphics in 'XENOME.OBS.Graphics.pas',
  XENOME.OBS.Properties in 'XENOME.OBS.Properties.pas',
  XENOME.OBS.Misc in 'XENOME.OBS.Misc.pas',
  XENOME.OBS.VideoScaler in 'XENOME.OBS.VideoScaler.pas';

{$R *.res}

var
  Module: POBSModule;
  RegisteredGlobalSignalHandler: POBSSignalHandler;

procedure OBSGlobalSignal(APrivateData: Pointer; ASignal: PAnsiChar; AParams: POBSCallData); cdecl;
var
  Source: POBSSource;
  NewName: PAnsiChar;
  PrevName: PAnsiChar;
begin
  if not AnsiSameText(String(AnsiString(ASignal)), 'source_rename') then
    Exit;

  Source:=POBSSource(calldata_ptr(AParams, 'source'));
  NewName:=calldata_string(AParams, 'new_name');
  PrevName:=calldata_string(AParams, 'prev_name');

  WriteLn('source_rename: id=', String(AnsiString(obs_source_get_id(Source))),
          ' prev=', String(AnsiString(PrevName)),
          ' new=', String(AnsiString(NewName)));
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

function OBSEnumOutputs(Param: Pointer; Source: POBSOutput): Boolean; cdecl;
var
  Video: POBSVideoOutput;
begin
  if AnsiSameText(String(AnsiString(obs_output_get_id(Source))), 'rtmp_output') then
  begin
    Video:=obs_get_video;

    WriteLn('obs_get_video_frame_time: ', obs_get_video_frame_time);
    WriteLn('obs_get_active_fps: ', obs_get_active_fps);
    WriteLn('obs_get_average_frame_time_ns: ', obs_get_average_frame_time_ns);
    WriteLn('obs_get_frame_interval_ns: ', obs_get_frame_interval_ns);
    WriteLn('obs_get_total_frames: ', obs_get_total_frames);
    WriteLn('obs_get_lagged_frames: ', obs_get_lagged_frames);

    WriteLn('video_output_get_frame_time: ', video_output_get_frame_time(Video));
    WriteLn('video_output_get_skipped_frames: ', video_output_get_skipped_frames(Video));
    WriteLn('video_output_get_total_frames: ', video_output_get_total_frames(Video));

    WriteLn('obs_output_get_total_bytes: ', obs_output_get_total_bytes(Source));
    WriteLn('obs_output_get_frames_dropped: ', obs_output_get_frames_dropped(Source));
    WriteLn('obs_output_get_total_frames: ', obs_output_get_total_frames(Source));
    WriteLn('obs_output_get_congestion: ', obs_output_get_congestion(Source));
    WriteLn('obs_output_get_connect_time_ms: ', obs_output_get_connect_time_ms(Source));
  end;

  Result:=True;
end;

procedure OBSRendered(AParam: Pointer); cdecl;
begin
  obs_enum_outputs(@OBSEnumOutputs, nil);
end;

procedure OBSToolsMenu(APrivateData: Pointer); cdecl;
begin
  WriteLn('OBSToolsMenu');
end;

function obs_module_load: Boolean; cdecl
begin
  obs_add_main_rendered_callback(@OBSRendered, nil);
  RegisteredGlobalSignalHandler:=obs_get_signal_handler;
  signal_handler_connect_global(RegisteredGlobalSignalHandler, @OBSGlobalSignal, nil);

  obs_frontend_add_tools_menu_item('Stats Export', @OBSToolsMenu, nil);

  WriteLn('SizeOf(TOBSVideoOutput) = ', SizeOf(TOBSVideoOutput));

  Result:=True;
end;

procedure obs_module_unload; cdecl;
begin
  if RegisteredGlobalSignalHandler <> nil then
    signal_handler_disconnect_global(RegisteredGlobalSignalHandler, @OBSGlobalSignal, nil);

  obs_remove_main_rendered_callback(@OBSRendered, nil);
end;

function obs_module_author: PAnsiChar; cdecl;
begin
  Result:='NaliLord';
end;

function obs_module_name: PAnsiChar; cdecl;
begin
  Result:='OBS Stats Exporter';
end;

function obs_module_description: PAnsiChar; cdecl;
begin
  Result:='Exports all OBS enconding and transport statistics.';
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
