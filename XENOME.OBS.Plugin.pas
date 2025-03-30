unit XENOME.OBS.Plugin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Win.Registry, System.IniFiles, System.Generics.Defaults,
  System.Generics.Collections, System.Contnrs, System.SyncObjs, XENOME.OBS, XENOME.OBS.Video, XENOME.OBS.Frontend;

implementation

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

function obs_module_load: Boolean; cdecl
begin
  Result:=True;
end;

function obs_module_author: PAnsiChar; cdecl;
begin
  Result:='NaliLord';
end;

function obs_module_name: PAnsiChar; cdecl;
begin
  Result:='OBS Delphi Plugin';
end;

function obs_module_description: PAnsiChar; cdecl;
begin
  Result:='An OBS plugin that is written in Delphi!';
end;

exports
  obs_module_set_pointer,
  obs_current_module,
  obs_module_ver,
  obs_module_load,
  obs_module_author,
  obs_module_name,
  obs_module_description;

end.
