library OBSDelphiTestPatternPlugin;

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
  XENOME.OBS.VideoScaler in '..\Source\XENOME.OBS.VideoScaler.pas',
  OBSDelphiTestPatternSource in 'OBSDelphiTestPatternSource.pas';

var
  Module: POBSModule;

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
  RegisterOBSDelphiTestPatternSource;
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
  Result:='OBS Delphi Test Pattern';
end;

function obs_module_description: PAnsiChar; cdecl;
begin
  Result:='Synthetic OBS source for validating Delphi video and audio bindings.';
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
end.
