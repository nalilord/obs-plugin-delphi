unit XENOME.OBS;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Win.Registry, System.IniFiles, System.Generics.Defaults,
  System.Generics.Collections, System.Contnrs, System.SyncObjs, XENOME.OBS.Types, XENOME.OBS.Video, XENOME.OBS.Data, XENOME.OBS.Properties, XENOME.OBS.Misc;

type
  TOBSHotkeyId = NativeUInt;
  TOBSHotkeyPairId = NativeUInt;

  POBSWeakRef = ^TOBSWeakRef;
  TOBSWeakRef = record
    [volatile] Refs: Longint;
    [volatile] WeakRefs: Longint;
  end;

  POBSWeakObject = ^TOBSWeakObject;
  TOBSWeakObject = record
    Ref: TOBSWeakRef;
    ObjectRef: Pointer;
  end;

  TOBSDestroyObjectProc = procedure(Obj: Pointer) cdecl;

  POBSSignalHandler = ^TOBSSignalHandler;
  TOBSSignalHandler = record
    First: Pointer;
    Mutex: Pointer;
    [volatile] Refs: Longint;
    GlobalCallbacks: TOBSDArray<Pointer>;
    GlobalCallbacksMutex: Pointer;
  end; // Debug-oriented, nested callback records intentionally left opaque

  POBSProcHandler = ^TOBSProcHandler;
  TOBSProcHandler = record
    Mutex: Pointer;
    Procs: TOBSDArray<Pointer>;
  end; // Debug-oriented, proc entries intentionally left opaque

  POBSContextData = ^TOBSContextData;
  PPOBSContextData = ^POBSContextData;
  TOBSContextData = record
    Name: PAnsiChar;
    UUID: PAnsiChar;
    Data: Pointer;
    Settings: POBSData;
    Signals: POBSSignalHandler;
    Procs: POBSProcHandler;
    Typ: TOBSObjType;
    Control: POBSWeakObject;
    Destroy: TOBSDestroyObjectProc;
    Hotkeys: TOBSDArray<TOBSHotkeyId>;
    HotkeyPairs: TOBSDArray<TOBSHotkeyPairId>;
    HotkeyData: POBSData;
    RenameCache: TOBSDArray<PAnsiChar>;
    RenameCacheMutex: Pointer;
    Mutex: PPointer;
    Next: POBSContextData;
    PrevNext: PPOBSContextData;
    HH: UT_hash_handle;
    HHUUID: UT_hash_handle;
    IsPrivate: Boolean;
  end;

  POBSSource = ^TOBSSource;
  TOBSSource = record
  end;

  POBSOutput = ^TOBSOutput;
  TOBSOutput = record
  end;

  POBSWeakOutput = ^TOBSWeakOutput;
  TOBSWeakOutput = record
  end;

  POBSEncoder = ^TOBSEncoder;
  TOBSEncoder = record
  end;

  POBSWeakEncoder = ^TOBSWeakEncoder;
  TOBSWeakEncoder = record
  end;

  POBSEncoderGroup = ^TOBSEncoderGroup;
  TOBSEncoderGroup = record
  end;

  POBSService = ^TOBSService;
  TOBSService = record
  end;

  POBSAudio = ^TOBSAudio;
  TOBSAudio = record
  end;

  POBSWeakService = ^TOBSWeakService;
  TOBSWeakService = record
  end;

  POBSWeakSource = ^TOBSWeakSource;
  TOBSWeakSource = record
    Ref: TOBSWeakRef;
    Source: POBSSource;
  end;

  POBSCanvas = ^TOBSCanvas;
  TOBSCanvas = record
  end;

  POBSWeakCanvas = ^TOBSWeakCanvas;
  TOBSWeakCanvas = record
    Ref: TOBSWeakRef;
    Canvas: POBSCanvas;
  end;

  POBSScene = ^TOBSScene;
  TOBSScene = record
  end; // Debug-only translation from obs-scene.h

  POBSSceneItem = ^TOBSSceneItem;
  TOBSSceneItem = record
  end; // Debug-only translation from obs-scene.h

  POBSCallData = ^TOBSCallData;
  TOBSCallData = record
    Stack: PByte;
    Size: NativeUInt;
    Capacity: NativeUInt;
    Fixed: Boolean;
  end;

type
  TOBSProc = procedure cdecl;
  TOBSFunc<TResult> = function: TResult cdecl;

  TOBSRenderedCallback = procedure(Param: Pointer) cdecl;
  TOBSTickCallback = procedure(Param: Pointer; Seconds: Single) cdecl;
  TOBSMainRenderCallback = procedure(Param: Pointer; CX, CY: Cardinal) cdecl;
  TOBSAudioDeviceEnumCallback = function(Param: Pointer; Name, Id: PAnsiChar): Boolean cdecl;
  TOBSRawVideoCallback = procedure(Param: Pointer; Frame: POBSVideoData) cdecl;
  TOBSTaskCallback = procedure(Param: Pointer) cdecl;
  TOBSTaskHandlerCallback = procedure(Task: TOBSTaskCallback; Param: Pointer; Wait: Boolean) cdecl;
  TOBSSignalCallback = procedure(Data: Pointer; Params: POBSCallData) cdecl;
  TOBSGlobalSignalCallback = procedure(Data: Pointer; Signal: PAnsiChar; Params: POBSCallData) cdecl;
  TOBSProcHandlerProc = procedure(Data: Pointer; Params: POBSCallData) cdecl;

  TOBSEnumSourcesCallback = function(Param: Pointer; Source: POBSSource): Boolean cdecl;
  POBSEnumSourcesCallback = TOBSEnumSourcesCallback;

  TOBSEnumOutputsCallback = function(Param: Pointer; Source: POBSOutput): Boolean cdecl;
  POBSEnumOutputsCallback = TOBSEnumOutputsCallback;

  TOBSEnumEncodersCallback = function(Param: Pointer; Source: POBSEncoder): Boolean cdecl;
  POBSEnumEncodersCallback = TOBSEnumEncodersCallback;

  TOBSEnumServicesCallback = function(Param: Pointer; Source: POBSService): Boolean cdecl;
  POBSEnumServicesCallback = TOBSEnumServicesCallback;

  TOBSEnumCanvasesCallback = function(Param: Pointer; Canvas: POBSCanvas): Boolean cdecl;
  POBSEnumCanvasesCallback = TOBSEnumCanvasesCallback;

  type
  POBSModule = ^TOBSModule;
  POBSModuleMetadata = ^TOBSModuleMetadata;
  TOBSModuleMetadata = record
    DisplayName: PAnsiChar;
    Version: PAnsiChar;
    Id: PAnsiChar;
    OSArch: PAnsiChar;
    Description: PAnsiChar;
    LongDescription: PAnsiChar;
    HasIcon: Boolean;
    HasBanner: Boolean;
    RepositoryUrl: PAnsiChar;
    SupportUrl: PAnsiChar;
    WebsiteUrl: PAnsiChar;
  end;

  TOBSModule = record  // You should NOT use this directly, only translated for debugging purposes!
    ModuleName: PAnsiChar;
    FileName: PAnsiChar;
    BinPath: PAnsiChar;
    DataPath: PAnsiChar;
    Module: Pointer;
    Loaded: Boolean;
    LoadState: TOBSModuleLoadState;
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
    Metadata: POBSModuleMetadata;
    Next: POBSModule;
    Sources: TOBSDArray<PAnsiChar>;
    Outputs: TOBSDArray<PAnsiChar>;
    Encoders: TOBSDArray<PAnsiChar>;
    Services: TOBSDArray<PAnsiChar>;
  end;

procedure obs_log(ALogLevel: Integer; const AFormat: PAnsiChar); cdecl; varargs; external 'obs.dll' name 'blog';
procedure bfree(APtr: Pointer); cdecl; external 'obs.dll' name 'bfree';

procedure obs_shutdown; cdecl; external 'obs.dll' name 'obs_shutdown';
function obs_initialized: Boolean; cdecl; external 'obs.dll' name 'obs_initialized';
function obs_get_version: Cardinal; cdecl; external 'obs.dll' name 'obs_get_version';
function obs_get_version_string: PAnsiChar; cdecl; external 'obs.dll' name 'obs_get_version_string';
procedure obs_reset_source_uuids; cdecl; external 'obs.dll' name 'obs_reset_source_uuids';
function obs_obj_get_type(AObj: Pointer): TOBSObjType; cdecl; external 'obs.dll' name 'obs_obj_get_type';
function obs_obj_get_id(AObj: Pointer): PAnsiChar; cdecl; external 'obs.dll' name 'obs_obj_get_id';
function obs_obj_invalid(AObj: Pointer): Boolean; cdecl; external 'obs.dll' name 'obs_obj_invalid';
function obs_obj_get_data(AObj: Pointer): Pointer; cdecl; external 'obs.dll' name 'obs_obj_get_data';
function obs_obj_is_private(AObj: Pointer): Boolean; cdecl; external 'obs.dll' name 'obs_obj_is_private';
function obs_object_get_ref(AObject: Pointer): Pointer; cdecl; external 'obs.dll' name 'obs_object_get_ref';
procedure obs_object_release(AObject: Pointer); cdecl; external 'obs.dll' name 'obs_object_release';
procedure obs_weak_object_addref(AWeak: POBSWeakObject); cdecl; external 'obs.dll' name 'obs_weak_object_addref';
procedure obs_weak_object_release(AWeak: POBSWeakObject); cdecl; external 'obs.dll' name 'obs_weak_object_release';
function obs_object_get_weak_object(AObject: Pointer): POBSWeakObject; cdecl; external 'obs.dll' name 'obs_object_get_weak_object';
function obs_weak_object_get_object(AWeak: POBSWeakObject): Pointer; cdecl; external 'obs.dll' name 'obs_weak_object_get_object';
function obs_weak_object_expired(AWeak: POBSWeakObject): Boolean; cdecl; external 'obs.dll' name 'obs_weak_object_expired';
function obs_weak_object_references_object(AWeak: POBSWeakObject; AObject: Pointer): Boolean; cdecl; external 'obs.dll' name 'obs_weak_object_references_object';
function obs_audio_monitoring_available: Boolean; cdecl; external 'obs.dll' name 'obs_audio_monitoring_available';
procedure obs_reset_audio_monitoring; cdecl; external 'obs.dll' name 'obs_reset_audio_monitoring';
procedure obs_enum_audio_monitoring_devices(ACallback: TOBSAudioDeviceEnumCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_enum_audio_monitoring_devices';
function obs_set_audio_monitoring_device(AName, AId: PAnsiChar): Boolean; cdecl; external 'obs.dll' name 'obs_set_audio_monitoring_device';
procedure obs_get_audio_monitoring_device(AName, AId: PPAnsiChar); cdecl; external 'obs.dll' name 'obs_get_audio_monitoring_device';
function obs_get_signal_handler: POBSSignalHandler; cdecl; external 'obs.dll' name 'obs_get_signal_handler';
function obs_get_proc_handler: POBSProcHandler; cdecl; external 'obs.dll' name 'obs_get_proc_handler';

procedure obs_add_tick_callback(ACallback: TOBSTickCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_add_tick_callback';
procedure obs_remove_tick_callback(ACallback: TOBSTickCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_remove_tick_callback';
procedure obs_add_main_render_callback(ACallback: TOBSMainRenderCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_add_main_render_callback';
procedure obs_remove_main_render_callback(ACallback: TOBSMainRenderCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_remove_main_render_callback';
procedure obs_add_main_rendered_callback(ACallback: TOBSRenderedCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_add_main_rendered_callback';
procedure obs_remove_main_rendered_callback(ACallback: TOBSRenderedCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_remove_main_rendered_callback';
procedure obs_add_raw_video_callback(AConversion: POBSVideoScaleInfo; ACallback: TOBSRawVideoCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_add_raw_video_callback';
procedure obs_add_raw_video_callback2(AConversion: POBSVideoScaleInfo; AFrameRateDivisor: Cardinal; ACallback: TOBSRawVideoCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_add_raw_video_callback2';
procedure obs_remove_raw_video_callback(ACallback: TOBSRawVideoCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_remove_raw_video_callback';
procedure obs_apply_private_data(ASettings: POBSData); cdecl; external 'obs.dll' name 'obs_apply_private_data';
procedure obs_set_private_data(ASettings: POBSData); cdecl; external 'obs.dll' name 'obs_set_private_data';
function obs_get_private_data: POBSData; cdecl; external 'obs.dll' name 'obs_get_private_data';
procedure obs_queue_task(ATyp: TOBSTaskType; ATask: TOBSTaskCallback; AParam: Pointer; AWait: Boolean); cdecl; external 'obs.dll' name 'obs_queue_task';
function obs_in_task_thread(ATyp: TOBSTaskType): Boolean; cdecl; external 'obs.dll' name 'obs_in_task_thread';
function obs_wait_for_destroy_queue: Boolean; cdecl; external 'obs.dll' name 'obs_wait_for_destroy_queue';
procedure obs_set_ui_task_handler(AHandler: TOBSTaskHandlerCallback); cdecl; external 'obs.dll' name 'obs_set_ui_task_handler';

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
function obs_get_canvas_by_name(AName: PAnsiChar): POBSCanvas; cdecl; external 'obs.dll' name 'obs_get_canvas_by_name';
function obs_get_canvas_by_uuid(AUUID: PAnsiChar): POBSCanvas; cdecl; external 'obs.dll' name 'obs_get_canvas_by_uuid';
function obs_output_get_signal_handler(AOutput: POBSOutput): POBSSignalHandler; cdecl; external 'obs.dll' name 'obs_output_get_signal_handler';
function obs_output_get_proc_handler(AOutput: POBSOutput): POBSProcHandler; cdecl; external 'obs.dll' name 'obs_output_get_proc_handler';
function obs_service_get_signal_handler(AService: POBSService): POBSSignalHandler; cdecl; external 'obs.dll' name 'obs_service_get_signal_handler';
function obs_service_get_proc_handler(AService: POBSService): POBSProcHandler; cdecl; external 'obs.dll' name 'obs_service_get_proc_handler';
procedure obs_render_canvas_texture(ACanvas: POBSCanvas); cdecl; external 'obs.dll' name 'obs_render_canvas_texture';
procedure obs_render_canvas_texture_src_color_only(ACanvas: POBSCanvas); cdecl; external 'obs.dll' name 'obs_render_canvas_texture_src_color_only';

procedure obs_enum_sources(ACallback: POBSEnumSourcesCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_enum_sources';
procedure obs_enum_scenes(ACallback: POBSEnumSourcesCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_enum_scenes';
procedure obs_enum_all_sources(ACallback: POBSEnumSourcesCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_enum_all_sources';
procedure obs_enum_outputs(ACallback: POBSEnumOutputsCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_enum_outputs';
procedure obs_enum_encoders(ACallback: POBSEnumEncodersCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_enum_encoders';
procedure obs_enum_services(ACallback: POBSEnumServicesCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_enum_services';
procedure obs_enum_canvases(ACallback: POBSEnumCanvasesCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_enum_canvases';

function obs_get_encoder_codec(AID: PAnsiChar): PAnsiChar; cdecl; external 'obs.dll' name 'obs_get_encoder_codec';
function obs_get_encoder_type(AID: PAnsiChar): TOBSEncoderType; cdecl; external 'obs.dll' name 'obs_get_encoder_type';
function obs_encoder_get_display_name(AID: PAnsiChar): PAnsiChar; cdecl; external 'obs.dll' name 'obs_encoder_get_display_name';
function obs_encoder_get_name(AEncoder: POBSEncoder): PAnsiChar; cdecl; external 'obs.dll' name 'obs_encoder_get_name';
function obs_encoder_get_id(AEncoder: POBSEncoder): PAnsiChar; cdecl; external 'obs.dll' name 'obs_encoder_get_id';
function obs_encoder_get_codec(AEncoder: POBSEncoder): PAnsiChar; cdecl; external 'obs.dll' name 'obs_encoder_get_codec';
function obs_encoder_get_type(AEncoder: POBSEncoder): TOBSEncoderType; cdecl; external 'obs.dll' name 'obs_encoder_get_type';
function obs_encoder_get_width(AEncoder: POBSEncoder): Cardinal; cdecl; external 'obs.dll' name 'obs_encoder_get_width';
function obs_encoder_get_height(AEncoder: POBSEncoder): Cardinal; cdecl; external 'obs.dll' name 'obs_encoder_get_height';
function obs_encoder_scaling_enabled(AEncoder: POBSEncoder): Boolean; cdecl; external 'obs.dll' name 'obs_encoder_scaling_enabled';
function obs_encoder_gpu_scaling_enabled(AEncoder: POBSEncoder): Boolean; cdecl; external 'obs.dll' name 'obs_encoder_gpu_scaling_enabled';
function obs_output_get_display_name(AID: PAnsiChar): PAnsiChar; cdecl; external 'obs.dll' name 'obs_output_get_display_name';
function obs_output_get_module(AID: PAnsiChar): POBSModule; cdecl; external 'obs.dll' name 'obs_output_get_module';
function obs_output_load_state(AID: PAnsiChar): TOBSModuleLoadState; cdecl; external 'obs.dll' name 'obs_output_load_state';
function obs_output_create(AID, AName: PAnsiChar; ASettings, AHotkeyData: POBSData): POBSOutput; cdecl; external 'obs.dll' name 'obs_output_create';
procedure obs_output_release(AOutput: POBSOutput); cdecl; external 'obs.dll' name 'obs_output_release';
procedure obs_weak_output_addref(AWeak: POBSWeakOutput); cdecl; external 'obs.dll' name 'obs_weak_output_addref';
procedure obs_weak_output_release(AWeak: POBSWeakOutput); cdecl; external 'obs.dll' name 'obs_weak_output_release';
function obs_output_get_ref(AOutput: POBSOutput): POBSOutput; cdecl; external 'obs.dll' name 'obs_output_get_ref';
function obs_output_get_weak_output(AOutput: POBSOutput): POBSWeakOutput; cdecl; external 'obs.dll' name 'obs_output_get_weak_output';
function obs_weak_output_get_output(AWeak: POBSWeakOutput): POBSOutput; cdecl; external 'obs.dll' name 'obs_weak_output_get_output';
function obs_weak_output_references_output(AWeak: POBSWeakOutput; AOutput: POBSOutput): Boolean; cdecl; external 'obs.dll' name 'obs_weak_output_references_output';
function obs_output_start(AOutput: POBSOutput): Boolean; cdecl; external 'obs.dll' name 'obs_output_start';
procedure obs_output_stop(AOutput: POBSOutput); cdecl; external 'obs.dll' name 'obs_output_stop';
procedure obs_output_set_delay(AOutput: POBSOutput; ADelaySec, AFlags: Cardinal); cdecl; external 'obs.dll' name 'obs_output_set_delay';
function obs_output_get_delay(AOutput: POBSOutput): Cardinal; cdecl; external 'obs.dll' name 'obs_output_get_delay';
function obs_output_get_active_delay(AOutput: POBSOutput): Cardinal; cdecl; external 'obs.dll' name 'obs_output_get_active_delay';
procedure obs_output_force_stop(AOutput: POBSOutput); cdecl; external 'obs.dll' name 'obs_output_force_stop';
function obs_output_get_flags(AOutput: POBSOutput): Cardinal; cdecl; external 'obs.dll' name 'obs_output_get_flags';
function obs_get_output_flags(AID: PAnsiChar): Cardinal; cdecl; external 'obs.dll' name 'obs_get_output_flags';
function obs_output_defaults(AID: PAnsiChar): POBSData; cdecl; external 'obs.dll' name 'obs_output_defaults';
function obs_get_output_properties(AID: PAnsiChar): POBSProperties; cdecl; external 'obs.dll' name 'obs_get_output_properties';
function obs_output_properties(AOutput: POBSOutput): POBSProperties; cdecl; external 'obs.dll' name 'obs_output_properties';
procedure obs_output_update(AOutput: POBSOutput; ASettings: POBSData); cdecl; external 'obs.dll' name 'obs_output_update';
function obs_output_can_pause(AOutput: POBSOutput): Boolean; cdecl; external 'obs.dll' name 'obs_output_can_pause';
function obs_output_pause(AOutput: POBSOutput; APause: Boolean): Boolean; cdecl; external 'obs.dll' name 'obs_output_pause';
function obs_output_paused(AOutput: POBSOutput): Boolean; cdecl; external 'obs.dll' name 'obs_output_paused';
function obs_output_get_settings(AOutput: POBSOutput): POBSData; cdecl; external 'obs.dll' name 'obs_output_get_settings';
procedure obs_output_set_media(AOutput: POBSOutput; AVideo: POBSVideoOutput; AAudio: POBSAudio); cdecl; external 'obs.dll' name 'obs_output_set_media';
function obs_output_video(AOutput: POBSOutput): POBSVideoOutput; cdecl; external 'obs.dll' name 'obs_output_video';
function obs_output_audio(AOutput: POBSOutput): POBSAudio; cdecl; external 'obs.dll' name 'obs_output_audio';
procedure obs_output_set_mixer(AOutput: POBSOutput; AMixerIdx: NativeUInt); cdecl; external 'obs.dll' name 'obs_output_set_mixer';
function obs_output_get_mixer(AOutput: POBSOutput): NativeUInt; cdecl; external 'obs.dll' name 'obs_output_get_mixer';
procedure obs_output_set_mixers(AOutput: POBSOutput; AMixers: NativeUInt); cdecl; external 'obs.dll' name 'obs_output_set_mixers';
function obs_output_get_mixers(AOutput: POBSOutput): NativeUInt; cdecl; external 'obs.dll' name 'obs_output_get_mixers';
procedure obs_output_set_video_encoder(AOutput: POBSOutput; AEncoder: POBSEncoder); cdecl; external 'obs.dll' name 'obs_output_set_video_encoder';
procedure obs_output_set_video_encoder2(AOutput: POBSOutput; AEncoder: POBSEncoder; AIdx: NativeUInt); cdecl; external 'obs.dll' name 'obs_output_set_video_encoder2';
procedure obs_output_set_audio_encoder(AOutput: POBSOutput; AEncoder: POBSEncoder; AIdx: NativeUInt); cdecl; external 'obs.dll' name 'obs_output_set_audio_encoder';
function obs_output_get_video_encoder(AOutput: POBSOutput): POBSEncoder; cdecl; external 'obs.dll' name 'obs_output_get_video_encoder';
function obs_output_get_video_encoder2(AOutput: POBSOutput; AIdx: NativeUInt): POBSEncoder; cdecl; external 'obs.dll' name 'obs_output_get_video_encoder2';
function obs_output_get_audio_encoder(AOutput: POBSOutput; AIdx: NativeUInt): POBSEncoder; cdecl; external 'obs.dll' name 'obs_output_get_audio_encoder';
procedure obs_output_set_service(AOutput: POBSOutput; AService: POBSService); cdecl; external 'obs.dll' name 'obs_output_set_service';
function obs_output_get_service(AOutput: POBSOutput): POBSService; cdecl; external 'obs.dll' name 'obs_output_get_service';
procedure obs_output_set_reconnect_settings(AOutput: POBSOutput; ARetryCount, ARetrySec: Integer); cdecl; external 'obs.dll' name 'obs_output_set_reconnect_settings';
procedure obs_output_set_preferred_size(AOutput: POBSOutput; AWidth, AHeight: Cardinal); cdecl; external 'obs.dll' name 'obs_output_set_preferred_size';
procedure obs_output_set_preferred_size2(AOutput: POBSOutput; AWidth, AHeight: Cardinal; AIdx: NativeUInt); cdecl; external 'obs.dll' name 'obs_output_set_preferred_size2';
function obs_output_get_width2(AOutput: POBSOutput; AIdx: NativeUInt): Cardinal; cdecl; external 'obs.dll' name 'obs_output_get_width2';
function obs_output_get_height2(AOutput: POBSOutput; AIdx: NativeUInt): Cardinal; cdecl; external 'obs.dll' name 'obs_output_get_height2';
procedure obs_output_caption(AOutput: POBSOutput; ACaptions: Pointer); cdecl; external 'obs.dll' name 'obs_output_caption';
procedure obs_output_output_caption_text1(AOutput: POBSOutput; AText: PAnsiChar); cdecl; external 'obs.dll' name 'obs_output_output_caption_text1';
procedure obs_output_output_caption_text2(AOutput: POBSOutput; AText: PAnsiChar; ADisplayDuration: Double); cdecl; external 'obs.dll' name 'obs_output_output_caption_text2';
procedure obs_output_set_last_error(AOutput: POBSOutput; AMessage: PAnsiChar); cdecl; external 'obs.dll' name 'obs_output_set_last_error';
function obs_output_get_last_error(AOutput: POBSOutput): PAnsiChar; cdecl; external 'obs.dll' name 'obs_output_get_last_error';
function obs_output_get_supported_video_codecs(AOutput: POBSOutput): PAnsiChar; cdecl; external 'obs.dll' name 'obs_output_get_supported_video_codecs';
function obs_output_get_supported_audio_codecs(AOutput: POBSOutput): PAnsiChar; cdecl; external 'obs.dll' name 'obs_output_get_supported_audio_codecs';
function obs_output_get_protocols(AOutput: POBSOutput): PAnsiChar; cdecl; external 'obs.dll' name 'obs_output_get_protocols';
function obs_output_get_type_data(AOutput: POBSOutput): Pointer; cdecl; external 'obs.dll' name 'obs_output_get_type_data';
function obs_output_can_begin_data_capture(AOutput: POBSOutput; AFlags: Cardinal): Boolean; cdecl; external 'obs.dll' name 'obs_output_can_begin_data_capture';
function obs_output_initialize_encoders(AOutput: POBSOutput; AFlags: Cardinal): Boolean; cdecl; external 'obs.dll' name 'obs_output_initialize_encoders';
function obs_output_begin_data_capture(AOutput: POBSOutput; AFlags: Cardinal): Boolean; cdecl; external 'obs.dll' name 'obs_output_begin_data_capture';
procedure obs_output_end_data_capture(AOutput: POBSOutput); cdecl; external 'obs.dll' name 'obs_output_end_data_capture';
procedure obs_output_signal_stop(AOutput: POBSOutput; ACode: Integer); cdecl; external 'obs.dll' name 'obs_output_signal_stop';
function obs_output_get_pause_offset(AOutput: POBSOutput): UInt64; cdecl; external 'obs.dll' name 'obs_output_get_pause_offset';

function obs_encoder_get_module(AID: PAnsiChar): POBSModule; cdecl; external 'obs.dll' name 'obs_encoder_get_module';
function obs_encoder_load_state(AID: PAnsiChar): TOBSModuleLoadState; cdecl; external 'obs.dll' name 'obs_encoder_load_state';
function obs_video_encoder_create(AID, AName: PAnsiChar; ASettings, AHotkeyData: POBSData): POBSEncoder; cdecl; external 'obs.dll' name 'obs_video_encoder_create';
function obs_audio_encoder_create(AID, AName: PAnsiChar; ASettings: POBSData; AMixerIdx: NativeUInt; AHotkeyData: POBSData): POBSEncoder; cdecl; external 'obs.dll' name 'obs_audio_encoder_create';
procedure obs_encoder_release(AEncoder: POBSEncoder); cdecl; external 'obs.dll' name 'obs_encoder_release';
procedure obs_weak_encoder_addref(AWeak: POBSWeakEncoder); cdecl; external 'obs.dll' name 'obs_weak_encoder_addref';
procedure obs_weak_encoder_release(AWeak: POBSWeakEncoder); cdecl; external 'obs.dll' name 'obs_weak_encoder_release';
function obs_encoder_get_ref(AEncoder: POBSEncoder): POBSEncoder; cdecl; external 'obs.dll' name 'obs_encoder_get_ref';
function obs_encoder_get_weak_encoder(AEncoder: POBSEncoder): POBSWeakEncoder; cdecl; external 'obs.dll' name 'obs_encoder_get_weak_encoder';
function obs_weak_encoder_get_encoder(AWeak: POBSWeakEncoder): POBSEncoder; cdecl; external 'obs.dll' name 'obs_weak_encoder_get_encoder';
function obs_weak_encoder_references_encoder(AWeak: POBSWeakEncoder; AEncoder: POBSEncoder): Boolean; cdecl; external 'obs.dll' name 'obs_weak_encoder_references_encoder';
procedure obs_encoder_set_name(AEncoder: POBSEncoder; AName: PAnsiChar); cdecl; external 'obs.dll' name 'obs_encoder_set_name';
procedure obs_encoder_set_scaled_size(AEncoder: POBSEncoder; AWidth, AHeight: Cardinal); cdecl; external 'obs.dll' name 'obs_encoder_set_scaled_size';
procedure obs_encoder_set_gpu_scale_type(AEncoder: POBSEncoder; AGPUScaleType: TOBSScaleType); cdecl; external 'obs.dll' name 'obs_encoder_set_gpu_scale_type';
function obs_encoder_set_frame_rate_divisor(AEncoder: POBSEncoder; ADivisor: Cardinal): Boolean; cdecl; external 'obs.dll' name 'obs_encoder_set_frame_rate_divisor';
function obs_encoder_get_scale_type(AEncoder: POBSEncoder): TOBSScaleType; cdecl; external 'obs.dll' name 'obs_encoder_get_scale_type';
function obs_encoder_get_frame_rate_divisor(AEncoder: POBSEncoder): Cardinal; cdecl; external 'obs.dll' name 'obs_encoder_get_frame_rate_divisor';
function obs_encoder_get_encoded_frames(AEncoder: POBSEncoder): Cardinal; cdecl; external 'obs.dll' name 'obs_encoder_get_encoded_frames';
function obs_encoder_get_sample_rate(AEncoder: POBSEncoder): Cardinal; cdecl; external 'obs.dll' name 'obs_encoder_get_sample_rate';
function obs_encoder_get_frame_size(AEncoder: POBSEncoder): NativeUInt; cdecl; external 'obs.dll' name 'obs_encoder_get_frame_size';
function obs_encoder_get_mixer_index(AEncoder: POBSEncoder): NativeUInt; cdecl; external 'obs.dll' name 'obs_encoder_get_mixer_index';
function obs_encoder_get_priming_samples(AEncoder: POBSEncoder): Cardinal; cdecl; external 'obs.dll' name 'obs_encoder_get_priming_samples';
procedure obs_encoder_set_preferred_video_format(AEncoder: POBSEncoder; AFormat: TOBSVideoFormat); cdecl; external 'obs.dll' name 'obs_encoder_set_preferred_video_format';
function obs_encoder_get_preferred_video_format(AEncoder: POBSEncoder): TOBSVideoFormat; cdecl; external 'obs.dll' name 'obs_encoder_get_preferred_video_format';
procedure obs_encoder_set_preferred_color_space(AEncoder: POBSEncoder; AColorspace: TOBSVideoColorspace); cdecl; external 'obs.dll' name 'obs_encoder_set_preferred_color_space';
function obs_encoder_get_preferred_color_space(AEncoder: POBSEncoder): TOBSVideoColorspace; cdecl; external 'obs.dll' name 'obs_encoder_get_preferred_color_space';
procedure obs_encoder_set_preferred_range(AEncoder: POBSEncoder; ARange: TOBSVideoRangeType); cdecl; external 'obs.dll' name 'obs_encoder_set_preferred_range';
function obs_encoder_get_preferred_range(AEncoder: POBSEncoder): TOBSVideoRangeType; cdecl; external 'obs.dll' name 'obs_encoder_get_preferred_range';
function obs_encoder_defaults(AID: PAnsiChar): POBSData; cdecl; external 'obs.dll' name 'obs_encoder_defaults';
function obs_encoder_get_defaults(AEncoder: POBSEncoder): POBSData; cdecl; external 'obs.dll' name 'obs_encoder_get_defaults';
function obs_get_encoder_properties(AID: PAnsiChar): POBSProperties; cdecl; external 'obs.dll' name 'obs_get_encoder_properties';
function obs_encoder_properties(AEncoder: POBSEncoder): POBSProperties; cdecl; external 'obs.dll' name 'obs_encoder_properties';
procedure obs_encoder_update(AEncoder: POBSEncoder; ASettings: POBSData); cdecl; external 'obs.dll' name 'obs_encoder_update';
function obs_encoder_get_settings(AEncoder: POBSEncoder): POBSData; cdecl; external 'obs.dll' name 'obs_encoder_get_settings';
procedure obs_encoder_set_video(AEncoder: POBSEncoder; AVideo: POBSVideoOutput); cdecl; external 'obs.dll' name 'obs_encoder_set_video';
procedure obs_encoder_set_audio(AEncoder: POBSEncoder; AAudio: POBSAudio); cdecl; external 'obs.dll' name 'obs_encoder_set_audio';
function obs_encoder_video(AEncoder: POBSEncoder): POBSVideoOutput; cdecl; external 'obs.dll' name 'obs_encoder_video';
function obs_encoder_parent_video(AEncoder: POBSEncoder): POBSVideoOutput; cdecl; external 'obs.dll' name 'obs_encoder_parent_video';
function obs_encoder_video_tex_active(AEncoder: POBSEncoder; AFormat: TOBSVideoFormat): Boolean; cdecl; external 'obs.dll' name 'obs_encoder_video_tex_active';
function obs_encoder_audio(AEncoder: POBSEncoder): POBSAudio; cdecl; external 'obs.dll' name 'obs_encoder_audio';
function obs_encoder_active(AEncoder: POBSEncoder): Boolean; cdecl; external 'obs.dll' name 'obs_encoder_active';
function obs_encoder_get_type_data(AEncoder: POBSEncoder): Pointer; cdecl; external 'obs.dll' name 'obs_encoder_get_type_data';
function obs_get_encoder_caps(AEncoderID: PAnsiChar): Cardinal; cdecl; external 'obs.dll' name 'obs_get_encoder_caps';
function obs_encoder_get_caps(AEncoder: POBSEncoder): Cardinal; cdecl; external 'obs.dll' name 'obs_encoder_get_caps';
function obs_encoder_paused(AEncoder: POBSEncoder): Boolean; cdecl; external 'obs.dll' name 'obs_encoder_paused';
function obs_encoder_get_last_error(AEncoder: POBSEncoder): PAnsiChar; cdecl; external 'obs.dll' name 'obs_encoder_get_last_error';
procedure obs_encoder_set_last_error(AEncoder: POBSEncoder; AMessage: PAnsiChar); cdecl; external 'obs.dll' name 'obs_encoder_set_last_error';
function obs_encoder_get_pause_offset(AEncoder: POBSEncoder): UInt64; cdecl; external 'obs.dll' name 'obs_encoder_get_pause_offset';
function obs_encoder_set_group(AEncoder: POBSEncoder; AGroup: POBSEncoderGroup): Boolean; cdecl; external 'obs.dll' name 'obs_encoder_set_group';
function obs_encoder_group_create: POBSEncoderGroup; cdecl; external 'obs.dll' name 'obs_encoder_group_create';
procedure obs_encoder_group_destroy(AGroup: POBSEncoderGroup); cdecl; external 'obs.dll' name 'obs_encoder_group_destroy';

function obs_service_get_display_name(AID: PAnsiChar): PAnsiChar; cdecl; external 'obs.dll' name 'obs_service_get_display_name';
function obs_service_get_module(AID: PAnsiChar): POBSModule; cdecl; external 'obs.dll' name 'obs_service_get_module';
function obs_service_load_state(AID: PAnsiChar): TOBSModuleLoadState; cdecl; external 'obs.dll' name 'obs_service_load_state';
function obs_service_create(AID, AName: PAnsiChar; ASettings, AHotkeyData: POBSData): POBSService; cdecl; external 'obs.dll' name 'obs_service_create';
function obs_service_create_private(AID, AName: PAnsiChar; ASettings: POBSData): POBSService; cdecl; external 'obs.dll' name 'obs_service_create_private';
procedure obs_service_release(AService: POBSService); cdecl; external 'obs.dll' name 'obs_service_release';
procedure obs_weak_service_addref(AWeak: POBSWeakService); cdecl; external 'obs.dll' name 'obs_weak_service_addref';
procedure obs_weak_service_release(AWeak: POBSWeakService); cdecl; external 'obs.dll' name 'obs_weak_service_release';
function obs_service_get_ref(AService: POBSService): POBSService; cdecl; external 'obs.dll' name 'obs_service_get_ref';
function obs_service_get_weak_service(AService: POBSService): POBSWeakService; cdecl; external 'obs.dll' name 'obs_service_get_weak_service';
function obs_weak_service_get_service(AWeak: POBSWeakService): POBSService; cdecl; external 'obs.dll' name 'obs_weak_service_get_service';
function obs_weak_service_references_service(AWeak: POBSWeakService; AService: POBSService): Boolean; cdecl; external 'obs.dll' name 'obs_weak_service_references_service';
function obs_service_get_name(AService: POBSService): PAnsiChar; cdecl; external 'obs.dll' name 'obs_service_get_name';
function obs_service_defaults(AID: PAnsiChar): POBSData; cdecl; external 'obs.dll' name 'obs_service_defaults';
function obs_get_service_properties(AID: PAnsiChar): POBSProperties; cdecl; external 'obs.dll' name 'obs_get_service_properties';
function obs_service_properties(AService: POBSService): POBSProperties; cdecl; external 'obs.dll' name 'obs_service_properties';
function obs_service_get_type(AService: POBSService): PAnsiChar; cdecl; external 'obs.dll' name 'obs_service_get_type';
procedure obs_service_update(AService: POBSService; ASettings: POBSData); cdecl; external 'obs.dll' name 'obs_service_update';
function obs_service_get_settings(AService: POBSService): POBSData; cdecl; external 'obs.dll' name 'obs_service_get_settings';
function obs_service_get_type_data(AService: POBSService): Pointer; cdecl; external 'obs.dll' name 'obs_service_get_type_data';
function obs_service_get_id(AService: POBSService): PAnsiChar; cdecl; external 'obs.dll' name 'obs_service_get_id';

function obs_output_get_id(AOutput: POBSOutput): PAnsiChar; cdecl; external 'obs.dll' name 'obs_output_get_id';
function obs_output_get_name(AOutput: POBSOutput): PAnsiChar; cdecl; external 'obs.dll' name 'obs_output_get_name';
function obs_output_get_total_bytes(AOutput: POBSOutput): UInt64; cdecl; external 'obs.dll' name 'obs_output_get_total_bytes';
function obs_output_get_frames_dropped(AOutput: POBSOutput): Integer; cdecl; external 'obs.dll' name 'obs_output_get_frames_dropped';
function obs_output_get_total_frames(AOutput: POBSOutput): Integer; cdecl; external 'obs.dll' name 'obs_output_get_total_frames';
function obs_output_get_width(AOutput: POBSOutput): Cardinal; cdecl; external 'obs.dll' name 'obs_output_get_width';
function obs_output_get_height(AOutput: POBSOutput): Cardinal; cdecl; external 'obs.dll' name 'obs_output_get_height';
function obs_output_get_congestion(AOutput: POBSOutput): Single; cdecl; external 'obs.dll' name 'obs_output_get_congestion';
function obs_output_get_connect_time_ms(AOutput: POBSOutput): Integer; cdecl; external 'obs.dll' name 'obs_output_get_connect_time_ms';
function obs_output_active(AOutput: POBSOutput): Boolean; cdecl; external 'obs.dll' name 'obs_output_active';
function obs_output_reconnecting(AOutput: POBSOutput): Boolean; cdecl; external 'obs.dll' name 'obs_output_reconnecting';

function signal_handler_create: POBSSignalHandler; cdecl; external 'obs.dll' name 'signal_handler_create';
procedure signal_handler_destroy(AHandler: POBSSignalHandler); cdecl; external 'obs.dll' name 'signal_handler_destroy';
function signal_handler_add(AHandler: POBSSignalHandler; ASignalDecl: PAnsiChar): Boolean; cdecl; external 'obs.dll' name 'signal_handler_add';
procedure signal_handler_connect(AHandler: POBSSignalHandler; ASignal: PAnsiChar; ACallback: TOBSSignalCallback; AData: Pointer); cdecl; external 'obs.dll' name 'signal_handler_connect';
procedure signal_handler_connect_ref(AHandler: POBSSignalHandler; ASignal: PAnsiChar; ACallback: TOBSSignalCallback; AData: Pointer); cdecl; external 'obs.dll' name 'signal_handler_connect_ref';
procedure signal_handler_disconnect(AHandler: POBSSignalHandler; ASignal: PAnsiChar; ACallback: TOBSSignalCallback; AData: Pointer); cdecl; external 'obs.dll' name 'signal_handler_disconnect';
procedure signal_handler_connect_global(AHandler: POBSSignalHandler; ACallback: TOBSGlobalSignalCallback; AData: Pointer); cdecl; external 'obs.dll' name 'signal_handler_connect_global';
procedure signal_handler_disconnect_global(AHandler: POBSSignalHandler; ACallback: TOBSGlobalSignalCallback; AData: Pointer); cdecl; external 'obs.dll' name 'signal_handler_disconnect_global';
procedure signal_handler_remove_current; cdecl; external 'obs.dll' name 'signal_handler_remove_current';
procedure signal_handler_signal(AHandler: POBSSignalHandler; ASignal: PAnsiChar; AParams: POBSCallData); cdecl; external 'obs.dll' name 'signal_handler_signal';

function proc_handler_create: POBSProcHandler; cdecl; external 'obs.dll' name 'proc_handler_create';
procedure proc_handler_destroy(AHandler: POBSProcHandler); cdecl; external 'obs.dll' name 'proc_handler_destroy';
procedure proc_handler_add(AHandler: POBSProcHandler; ADeclString: PAnsiChar; AProc: TOBSProcHandlerProc; AData: Pointer); cdecl; external 'obs.dll' name 'proc_handler_add';
function proc_handler_call(AHandler: POBSProcHandler; AName: PAnsiChar; AParams: POBSCallData): Boolean; cdecl; external 'obs.dll' name 'proc_handler_call';

function calldata_get_data(const AData: POBSCallData; AName: PAnsiChar; AOut: Pointer; ASize: NativeUInt): Boolean; cdecl; external 'obs.dll' name 'calldata_get_data';
procedure calldata_set_data(AData: POBSCallData; AName: PAnsiChar; const AIn: Pointer; ANewSize: NativeUInt); cdecl; external 'obs.dll' name 'calldata_set_data';
function calldata_get_string(const AData: POBSCallData; AName: PAnsiChar; out AStr: PAnsiChar): Boolean; cdecl; external 'obs.dll' name 'calldata_get_string';

procedure calldata_init(AData: POBSCallData);
procedure calldata_clear(AData: POBSCallData);
procedure calldata_init_fixed(AData: POBSCallData; AStack: PByte; ASize: NativeUInt);
procedure calldata_free(AData: POBSCallData);
function calldata_create: POBSCallData;
procedure calldata_destroy(AData: POBSCallData);

function calldata_get_int(const AData: POBSCallData; AName: PAnsiChar; out AValue: Int64): Boolean;
function calldata_get_float(const AData: POBSCallData; AName: PAnsiChar; out AValue: Double): Boolean;
function calldata_get_bool(const AData: POBSCallData; AName: PAnsiChar; out AValue: Boolean): Boolean;
function calldata_get_ptr(const AData: POBSCallData; AName: PAnsiChar; out AValue: Pointer): Boolean;

function calldata_int(const AData: POBSCallData; AName: PAnsiChar): Int64;
function calldata_float(const AData: POBSCallData; AName: PAnsiChar): Double;
function calldata_bool(const AData: POBSCallData; AName: PAnsiChar): Boolean;
function calldata_ptr(const AData: POBSCallData; AName: PAnsiChar): Pointer;
function calldata_string(const AData: POBSCallData; AName: PAnsiChar): PAnsiChar;

procedure calldata_set_int(AData: POBSCallData; AName: PAnsiChar; AValue: Int64);
procedure calldata_set_float(AData: POBSCallData; AName: PAnsiChar; AValue: Double);
procedure calldata_set_bool(AData: POBSCallData; AName: PAnsiChar; AValue: Boolean);
procedure calldata_set_ptr(AData: POBSCallData; AName: PAnsiChar; AValue: Pointer);
procedure calldata_set_string(AData: POBSCallData; AName: PAnsiChar; AValue: PAnsiChar);

implementation

procedure calldata_init(AData: POBSCallData);
begin
  if AData <> nil then
    FillChar(AData^, SizeOf(TOBSCallData), 0);
end;

procedure calldata_clear(AData: POBSCallData);
begin
  if (AData <> nil) and (AData.Stack <> nil) then
  begin
    AData.Size:=SizeOf(NativeUInt);
    FillChar(AData.Stack^, SizeOf(NativeUInt), 0);
  end;
end;

procedure calldata_init_fixed(AData: POBSCallData; AStack: PByte; ASize: NativeUInt);
begin
  if AData = nil then
    Exit;

  AData.Stack:=AStack;
  AData.Capacity:=ASize;
  AData.Fixed:=True;
  AData.Size:=0;
  calldata_clear(AData);
end;

procedure calldata_free(AData: POBSCallData);
begin
  if (AData <> nil) and not AData.Fixed then
    bfree(AData.Stack);
end;

function calldata_create: POBSCallData;
begin
  New(Result);
  calldata_init(Result);
end;

procedure calldata_destroy(AData: POBSCallData);
begin
  if AData = nil then
    Exit;

  calldata_free(AData);
  Dispose(AData);
end;

function calldata_get_int(const AData: POBSCallData; AName: PAnsiChar; out AValue: Int64): Boolean;
begin
  Result:=calldata_get_data(AData, AName, @AValue, SizeOf(AValue));
end;

function calldata_get_float(const AData: POBSCallData; AName: PAnsiChar; out AValue: Double): Boolean;
begin
  Result:=calldata_get_data(AData, AName, @AValue, SizeOf(AValue));
end;

function calldata_get_bool(const AData: POBSCallData; AName: PAnsiChar; out AValue: Boolean): Boolean;
begin
  Result:=calldata_get_data(AData, AName, @AValue, SizeOf(AValue));
end;

function calldata_get_ptr(const AData: POBSCallData; AName: PAnsiChar; out AValue: Pointer): Boolean;
begin
  Result:=calldata_get_data(AData, AName, @AValue, SizeOf(AValue));
end;

function calldata_int(const AData: POBSCallData; AName: PAnsiChar): Int64;
begin
  Result:=0;
  calldata_get_int(AData, AName, Result);
end;

function calldata_float(const AData: POBSCallData; AName: PAnsiChar): Double;
begin
  Result:=0.0;
  calldata_get_float(AData, AName, Result);
end;

function calldata_bool(const AData: POBSCallData; AName: PAnsiChar): Boolean;
begin
  Result:=False;
  calldata_get_bool(AData, AName, Result);
end;

function calldata_ptr(const AData: POBSCallData; AName: PAnsiChar): Pointer;
begin
  Result:=nil;
  calldata_get_ptr(AData, AName, Result);
end;

function calldata_string(const AData: POBSCallData; AName: PAnsiChar): PAnsiChar;
begin
  Result:=nil;
  calldata_get_string(AData, AName, Result);
end;

procedure calldata_set_int(AData: POBSCallData; AName: PAnsiChar; AValue: Int64);
begin
  calldata_set_data(AData, AName, @AValue, SizeOf(AValue));
end;

procedure calldata_set_float(AData: POBSCallData; AName: PAnsiChar; AValue: Double);
begin
  calldata_set_data(AData, AName, @AValue, SizeOf(AValue));
end;

procedure calldata_set_bool(AData: POBSCallData; AName: PAnsiChar; AValue: Boolean);
begin
  calldata_set_data(AData, AName, @AValue, SizeOf(AValue));
end;

procedure calldata_set_ptr(AData: POBSCallData; AName: PAnsiChar; AValue: Pointer);
begin
  calldata_set_data(AData, AName, @AValue, SizeOf(AValue));
end;

procedure calldata_set_string(AData: POBSCallData; AName: PAnsiChar; AValue: PAnsiChar);
begin
  if AValue <> nil then
    calldata_set_data(AData, AName, AValue, lstrlenA(AValue) + 1)
  else
    calldata_set_data(AData, AName, nil, 0);
end;

end.
