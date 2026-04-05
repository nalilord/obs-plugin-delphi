unit XENOME.OBS.Frontend;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Win.Registry, System.IniFiles, System.Generics.Defaults,
  System.Generics.Collections, System.Contnrs, System.SyncObjs, XENOME.OBS, XENOME.OBS.Types, XENOME.OBS.Source;

{$MINENUMSIZE 4}

type
  POBSFrontendSourceArray = ^TOBSFrontendSourceArray;
  TOBSFrontendSourceArray = array[0..MaxInt div SizeOf(POBSSource) - 1] of POBSSource;

  POBSFrontendSourceList = ^TOBSFrontendSourceList;
  TOBSFrontendSourceList = record
    Sources: TOBSDArray<POBSSource>;
  end;

  TOBSFrontendCallback = procedure(PrivateData: Pointer) cdecl;

{ Ownership notes:
  - obs_frontend_get_scene_names / obs_frontend_get_scene_collections /
    obs_frontend_get_profiles return a single owned char** allocation.
    Free with obs_frontend_string_list_free or bfree.
  - obs_frontend_get_current_scene_collection /
    obs_frontend_get_current_profile /
    obs_frontend_get_current_profile_path return owned char* strings.
    Free with obs_frontend_string_free or bfree.
  - obs_frontend_get_current_scene / obs_frontend_get_current_transition
    return new source references. Release with obs_source_release.
  - obs_frontend_get_scenes / obs_frontend_get_transitions populate
    reference-incremented source lists. Release with
    obs_frontend_source_list_free. }

procedure obs_frontend_source_list_free(ASourceList: POBSFrontendSourceList);
procedure obs_frontend_string_list_free(AStringList: PPAnsiChar);
procedure obs_frontend_string_free(AValue: PAnsiChar);

function obs_frontend_get_main_window: Pointer; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_get_main_window';
function obs_frontend_get_main_window_handle: Pointer; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_get_main_window_handle';
function obs_frontend_get_system_tray: Pointer; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_get_system_tray';

function obs_frontend_get_scene_names: PPAnsiChar; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_get_scene_names';
procedure obs_frontend_get_scenes(ASources: POBSFrontendSourceList); cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_get_scenes';
function obs_frontend_get_current_scene: POBSSource; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_get_current_scene';
procedure obs_frontend_set_current_scene(AScene: POBSSource); cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_set_current_scene';

procedure obs_frontend_get_transitions(ASources: POBSFrontendSourceList); cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_get_transitions';
function obs_frontend_get_current_transition: POBSSource; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_get_current_transition';
procedure obs_frontend_set_current_transition(ATransition: POBSSource); cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_set_current_transition';
function obs_frontend_get_transition_duration: Integer; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_get_transition_duration';
procedure obs_frontend_set_transition_duration(ADuration: Integer); cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_set_transition_duration';
procedure obs_frontend_release_tbar; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_release_tbar';
procedure obs_frontend_set_tbar_position(APosition: Integer); cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_set_tbar_position';
function obs_frontend_get_tbar_position: Integer; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_get_tbar_position';

function obs_frontend_get_scene_collections: PPAnsiChar; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_get_scene_collections';
function obs_frontend_get_current_scene_collection: PAnsiChar; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_get_current_scene_collection';
procedure obs_frontend_set_current_scene_collection(ACollection: PAnsiChar); cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_set_current_scene_collection';
function obs_frontend_add_scene_collection(AName: PAnsiChar): Boolean; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_add_scene_collection';

function obs_frontend_get_profiles: PPAnsiChar; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_get_profiles';
function obs_frontend_get_current_profile: PAnsiChar; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_get_current_profile';
function obs_frontend_get_current_profile_path: PAnsiChar; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_get_current_profile_path';
procedure obs_frontend_set_current_profile(AProfile: PAnsiChar); cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_set_current_profile';
procedure obs_frontend_create_profile(AName: PAnsiChar); cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_create_profile';
procedure obs_frontend_duplicate_profile(AName: PAnsiChar); cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_duplicate_profile';
procedure obs_frontend_delete_profile(AProfile: PAnsiChar); cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_delete_profile';

function obs_frontend_add_tools_menu_qaction(AName: PAnsiChar): Pointer; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_add_tools_menu_qaction';
procedure obs_frontend_add_tools_menu_item(AName: PAnsiChar; ACallback: TOBSFrontendCallback; APrivateData: Pointer); cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_add_tools_menu_item';

procedure obs_frontend_streaming_start; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_streaming_start';
procedure obs_frontend_streaming_stop; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_streaming_stop';
function obs_frontend_streaming_active: Boolean; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_streaming_active';

implementation

procedure obs_frontend_source_list_free(ASourceList: POBSFrontendSourceList);
var
  I: NativeUInt;
  Sources: POBSFrontendSourceArray;
begin
  if ASourceList = nil then
    Exit;

  Sources:=POBSFrontendSourceArray(ASourceList^.Sources.Data);
  for I:=0 to ASourceList^.Sources.Num - 1 do
    obs_source_release(Sources^[I]);

  ASourceList^.Sources.Data:=nil;
  ASourceList^.Sources.Num:=0;
  ASourceList^.Sources.Capacity:=0;
end;

procedure obs_frontend_string_list_free(AStringList: PPAnsiChar);
begin
  if AStringList <> nil then
    bfree(AStringList);
end;

procedure obs_frontend_string_free(AValue: PAnsiChar);
begin
  if AValue <> nil then
    bfree(AValue);
end;

end.
