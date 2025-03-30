unit XENOME.OBS;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Win.Registry, System.IniFiles, System.Generics.Defaults,
  System.Generics.Collections, System.Contnrs, System.SyncObjs, XENOME.OBS.Video;

const
  LIBOBS_API_MAJOR_VER = 30;
  LIBOBS_API_MINOR_VER = 0;
  LIBOBS_API_PATCH_VER = 2;
  LIBOBS_API_VER       = (LIBOBS_API_MAJOR_VER SHL 24) OR (LIBOBS_API_MINOR_VER SHL 16) OR LIBOBS_API_PATCH_VER;

const
	LOG_ERROR   = 100;
	LOG_WARNING = 200;
	LOG_INFO    = 300;
	LOG_DEBUG   = 400;

type
  TOBSEncoderType = (
    OBS_ENCODER_AUDIO,
    OBS_ENCODER_VIDEO
  );

type
  POBSSource = ^TOBSSource;
  TOBSSource = record
  end;

  POBSOutput = ^TOBSOutput;
  TOBSOutput = record
  end;

  POBSEncoder = ^TOBSEncoder;
  TOBSEncoder = record
  end;

  POBSService = ^TOBSService;
  TOBSService = record
  end;

type
  TOBSProc = reference to procedure cdecl;
  TOBSFunc<TResult> = reference to function: TResult cdecl;

  TOBSRenderedCallback = reference to procedure(Param: Pointer) cdecl;
  POBSRenderedCallback =^TOBSRenderedCallback;

  TOBSEnumSourcesCallback = reference to function(Param: Pointer; Source: POBSSource): Boolean cdecl;
  POBSEnumSourcesCallback = TOBSEnumSourcesCallback;

  TOBSEnumOutputsCallback = reference to function(Param: Pointer; Source: POBSOutput): Boolean cdecl;
  POBSEnumOutputsCallback = ^TOBSEnumOutputsCallback;

  TOBSEnumEncodersCallback = reference to function(Param: Pointer; Source: POBSEncoder): Boolean cdecl;
  POBSEnumEncodersCallback = ^TOBSEnumEncodersCallback;

  TOBSEnumServicesCallback = reference to function(Param: Pointer; Source: POBSService): Boolean cdecl;
  POBSEnumServicesCallback = ^TOBSEnumServicesCallback;

type
  POBSModule = ^TOBSModule;
  TOBSModule = record  // You should NOT use this directly, only translated for debugging purposes!
    ModuleName: PAnsiChar;
    FileName: PAnsiChar;
    BinPath: PAnsiChar;
    DataPath: PAnsiChar;
    Module: Pointer;
    Loaded: Boolean;
    Load: TOBSFunc<Boolean>;
    Unload: TOBSProc;
    PostLoad: TOBSProc;
    SetLocale: Pointer; // (*set_locale)(const char *locale);
    GetString: Pointer; // (*get_string)(const char *lookup_string, const char **translated_string);
    FreeLocale: TOBSProc;
    Ver: TOBSFunc<Cardinal>;
    SetPointer: Pointer; // (*set_pointer)(obs_module_t *module);
    Name: TOBSFunc<PAnsiChar>;
    Description: TOBSFunc<PAnsiChar>;
    Author: TOBSFunc<PAnsiChar>;
    Next: POBSModule;
  end;

procedure obs_log(ALogLevel: Integer; const AFormat: PAnsiChar); cdecl; varargs; external 'obs.dll' name 'blog';

procedure obs_shutdown; cdecl; external 'obs.dll' name 'obs_shutdown';
function obs_initialized: Boolean; cdecl; external 'obs.dll' name 'obs_initialized';
function obs_get_version: Cardinal; cdecl; external 'obs.dll' name 'obs_get_version';
function obs_get_version_string: PAnsiChar; cdecl; external 'obs.dll' name 'obs_get_version_string';

procedure obs_add_main_rendered_callback(ACallback: POBSRenderedCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_add_main_rendered_callback';

function obs_get_video_info(AVideoInfo: POBSVideoInfo): Boolean; cdecl; external 'obs.dll' name 'obs_get_video_info';
function obs_get_video_frame_time: UInt64; cdecl; external 'obs.dll' name 'obs_get_video_frame_time';
function obs_get_active_fps: Double; cdecl; external 'obs.dll' name 'obs_get_active_fps';
function obs_get_average_frame_time_ns: UInt64; cdecl; external 'obs.dll' name 'obs_get_average_frame_time_ns';
function obs_get_frame_interval_ns: UInt64; cdecl; external 'obs.dll' name 'obs_get_frame_interval_ns';
function obs_get_total_frames: Cardinal; cdecl; external 'obs.dll' name 'obs_get_total_frames';
function obs_get_lagged_frames: Cardinal; cdecl; external 'obs.dll' name 'obs_get_lagged_frames';

function obs_get_output_by_name(AName: PAnsiChar): POBSOutput; cdecl; external 'obs.dll' name 'obs_get_output_by_name';
function obs_get_encoder_by_name(AName: PAnsiChar): POBSEncoder; cdecl; external 'obs.dll' name 'obs_get_encoder_by_name';
function obs_get_service_by_name(AName: PAnsiChar): POBSService; cdecl; external 'obs.dll' name 'obs_get_service_by_name';

procedure obs_enum_sources(ACallback: POBSEnumSourcesCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_enum_sources';
procedure obs_enum_scenes(ACallback: POBSEnumSourcesCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_enum_scenes';
procedure obs_enum_all_sources(ACallback: POBSEnumSourcesCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_enum_all_sources';
procedure obs_enum_outputs(ACallback: POBSEnumOutputsCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_enum_outputs';
procedure obs_enum_encoders(ACallback: POBSEnumEncodersCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_enum_encoders';
procedure obs_enum_services(ACallback: POBSEnumServicesCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_enum_services';

function obs_get_encoder_codec(AID: PAnsiChar): PAnsiChar; cdecl; external 'obs.dll' name 'obs_get_encoder_codec';
function obs_get_encoder_type(AID: PAnsiChar): TOBSEncoderType; cdecl; external 'obs.dll' name 'obs_encoder_get_codec';
function obs_encoder_get_display_name(AID: PAnsiChar): PAnsiChar; cdecl; external 'obs.dll' name 'obs_encoder_get_display_name';
function obs_encoder_get_name(AEncoder: POBSEncoder): PAnsiChar; cdecl; external 'obs.dll' name 'obs_encoder_get_name';
function obs_encoder_get_id(AEncoder: POBSEncoder): PAnsiChar; cdecl; external 'obs.dll' name 'obs_encoder_get_id';
function obs_encoder_get_codec(AEncoder: POBSEncoder): PAnsiChar; cdecl; external 'obs.dll' name 'obs_encoder_get_codec';
function obs_encoder_get_type(AEncoder: POBSEncoder): TOBSEncoderType; cdecl; external 'obs.dll' name 'obs_encoder_get_type';
function obs_encoder_get_width(AEncoder: POBSEncoder): Cardinal; cdecl; external 'obs.dll' name 'obs_encoder_get_width';
function obs_encoder_get_height(AEncoder: POBSEncoder): Cardinal; cdecl; external 'obs.dll' name 'obs_encoder_get_height';
function obs_encoder_scaling_enabled(AEncoder: POBSEncoder): Boolean; cdecl; external 'obs.dll' name 'obs_encoder_scaling_enabled';
function obs_encoder_gpu_scaling_enabled(AEncoder: POBSEncoder): Boolean; cdecl; external 'obs.dll' name 'obs_encoder_gpu_scaling_enabled';

function obs_output_get_id(AOutput: POBSOutput): PAnsiChar; cdecl; external 'obs.dll' name 'obs_output_get_id';
function obs_output_get_name(AOutput: POBSOutput): PAnsiChar; cdecl; external 'obs.dll' name 'obs_output_get_name';
function obs_output_get_display_name(AID: PAnsiChar): PAnsiChar; cdecl; external 'obs.dll' name 'obs_output_get_display_name';
function obs_output_get_total_bytes(AOutput: POBSOutput): UInt64; cdecl; external 'obs.dll' name 'obs_output_get_total_bytes';
function obs_output_get_frames_dropped(AOutput: POBSOutput): Integer; cdecl; external 'obs.dll' name 'obs_output_get_frames_dropped';
function obs_output_get_total_frames(AOutput: POBSOutput): Integer; cdecl; external 'obs.dll' name 'obs_output_get_total_frames';
function obs_output_get_width(AOutput: POBSOutput): Cardinal; cdecl; external 'obs.dll' name 'obs_output_get_width';
function obs_output_get_height(AOutput: POBSOutput): Cardinal; cdecl; external 'obs.dll' name 'obs_output_get_height';
function obs_output_get_congestion(AOutput: POBSOutput): Single; cdecl; external 'obs.dll' name 'obs_output_get_congestion';
function obs_output_get_connect_time_ms(AOutput: POBSOutput): Integer; cdecl; external 'obs.dll' name 'obs_output_get_connect_time_ms';
function obs_output_active(AOutput: POBSOutput): Boolean; cdecl; external 'obs.dll' name 'obs_output_active';
function obs_output_reconnecting(AOutput: POBSOutput): Boolean; cdecl; external 'obs.dll' name 'obs_output_reconnecting';

implementation

end.
