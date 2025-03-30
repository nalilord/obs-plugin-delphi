unit XENOME.OBS.Frontend;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Win.Registry, System.IniFiles, System.Generics.Defaults,
  System.Generics.Collections, System.Contnrs, System.SyncObjs, XENOME.OBS;

type
  TOBSFrontendEvent = (
    OBS_FRONTEND_EVENT_STREAMING_STARTING,
    OBS_FRONTEND_EVENT_STREAMING_STARTED,
    OBS_FRONTEND_EVENT_STREAMING_STOPPING,
    OBS_FRONTEND_EVENT_STREAMING_STOPPED,
    OBS_FRONTEND_EVENT_RECORDING_STARTING,
    OBS_FRONTEND_EVENT_RECORDING_STARTED,
    OBS_FRONTEND_EVENT_RECORDING_STOPPING,
    OBS_FRONTEND_EVENT_RECORDING_STOPPED,
    OBS_FRONTEND_EVENT_SCENE_CHANGED,
    OBS_FRONTEND_EVENT_SCENE_LIST_CHANGED,
    OBS_FRONTEND_EVENT_TRANSITION_CHANGED,
    OBS_FRONTEND_EVENT_TRANSITION_STOPPED,
    OBS_FRONTEND_EVENT_TRANSITION_LIST_CHANGED,
    OBS_FRONTEND_EVENT_SCENE_COLLECTION_CHANGED,
    OBS_FRONTEND_EVENT_SCENE_COLLECTION_LIST_CHANGED,
    OBS_FRONTEND_EVENT_PROFILE_CHANGED,
    OBS_FRONTEND_EVENT_PROFILE_LIST_CHANGED,
    OBS_FRONTEND_EVENT_EXIT,

    OBS_FRONTEND_EVENT_REPLAY_BUFFER_STARTING,
    OBS_FRONTEND_EVENT_REPLAY_BUFFER_STARTED,
    OBS_FRONTEND_EVENT_REPLAY_BUFFER_STOPPING,
    OBS_FRONTEND_EVENT_REPLAY_BUFFER_STOPPED,

    OBS_FRONTEND_EVENT_STUDIO_MODE_ENABLED,
    OBS_FRONTEND_EVENT_STUDIO_MODE_DISABLED,
    OBS_FRONTEND_EVENT_PREVIEW_SCENE_CHANGED,

    OBS_FRONTEND_EVENT_SCENE_COLLECTION_CLEANUP,
    OBS_FRONTEND_EVENT_FINISHED_LOADING,

    OBS_FRONTEND_EVENT_RECORDING_PAUSED,
    OBS_FRONTEND_EVENT_RECORDING_UNPAUSED,

    OBS_FRONTEND_EVENT_TRANSITION_DURATION_CHANGED,
    OBS_FRONTEND_EVENT_REPLAY_BUFFER_SAVED,

    OBS_FRONTEND_EVENT_VIRTUALCAM_STARTED,
    OBS_FRONTEND_EVENT_VIRTUALCAM_STOPPED,

    OBS_FRONTEND_EVENT_TBAR_VALUE_CHANGED,
    OBS_FRONTEND_EVENT_SCENE_COLLECTION_CHANGING,
    OBS_FRONTEND_EVENT_PROFILE_CHANGING,
    OBS_FRONTEND_EVENT_SCRIPTING_SHUTDOWN,
    OBS_FRONTEND_EVENT_PROFILE_RENAMED,
    OBS_FRONTEND_EVENT_SCENE_COLLECTION_RENAMED,
    OBS_FRONTEND_EVENT_THEME_CHANGED,
    OBS_FRONTEND_EVENT_SCREENSHOT_TAKEN
  );

  POBSFrontendSourceList = ^TOBSFrontendSourceList;
  TOBSFrontendSourceList = record
  end;

  TOBSFrontendCallback = reference to function(PrivateData: Pointer): Boolean cdecl;
  POBSFrontendCallback = ^TOBSFrontendCallback;

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
procedure obs_frontend_add_tools_menu_item(AName: PAnsiChar; ACallback: POBSFrontendCallback; APrivateData: Pointer); cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_add_tools_menu_item';

procedure obs_frontend_streaming_start; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_streaming_start';
procedure obs_frontend_streaming_stop; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_streaming_stop';
function obs_frontend_streaming_active: Boolean; cdecl; external 'obs-frontend-api.dll' name 'obs_frontend_streaming_active';

implementation

end.
