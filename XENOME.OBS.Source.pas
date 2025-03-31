unit XENOME.OBS.Source;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Win.Registry, System.IniFiles, System.Generics.Defaults,
  System.Generics.Collections, System.Contnrs, System.SyncObjs, XENOME.OBS, XENOME.OBS.Types, XENOME.OBS.Data, XENOME.OBS.Audio;

type
  TOBSSourceProc<TParam> = reference to procedure(Param: TParam) cdecl;
  TOBSSourceProc2<TParam,TParam2> = reference to procedure(Param: TParam; Param2: TParam2) cdecl;
  TOBSSourceProc3<TParam,TParam2,TParam3> = reference to procedure(Param: TParam; Param2: TParam2; Param3: TParam3) cdecl;
  TOBSSourceProc4<TParam,TParam2,TParam3,TParam4> = reference to procedure(Param: TParam; Param2: TParam2; Param3: TParam3; Param4: TParam4) cdecl;
  TOBSSourceProc5<TParam,TParam2,TParam3,TParam4,TParam5> = reference to procedure(Param: TParam; Param2: TParam2; Param3: TParam3; Param4: TParam4; Param5: TParam5) cdecl;
  TOBSSourceFunc<TResult,TParam> = reference to function(Param: TParam): TResult cdecl;
  TOBSSourceFunc2<TResult,TParam,TParam2> = reference to function(Param: TParam; Param2: TParam2): TResult cdecl;
  TOBSSourceFunc3<TResult,TParam,TParam2,TParam3> = reference to function(Param: TParam; Param2: TParam2; Param3: TParam3): TResult cdecl;
  TOBSSourceFunc4<TResult,TParam,TParam2,TParam3,TParam4> = reference to function(Param: TParam; Param2: TParam2; Param3: TParam3; Param4: TParam4): TResult cdecl;
  TOBSSourceFunc5<TResult,TParam,TParam2,TParam3,TParam4,TParam5> = reference to function(Param: TParam; Param2: TParam2; Param3: TParam3; Param4: TParam4; Param5: TParam5): TResult cdecl;
  TOBSSourceFunc6<TResult,TParam,TParam2,TParam3,TParam4,TParam5,TParam6> = reference to function(Param: TParam; Param2: TParam2; Param3: TParam3; Param4: TParam4; Param5: TParam5; Param6: TParam6): TResult cdecl;
  TOBSSourceGetNameFunc = reference to function(TypeData: Pointer): PAnsiChar cdecl;
  TOBSSourceCreateFunc = reference to function(Settings: POBSData; Source: POBSSource): Pointer cdecl;
  TOBSSourceDestroyProc = reference to procedure(Data: Pointer) cdecl;

  TOBSSourceEnumCallback = reference to procedure(Parent, Child: POBSSource; Param: Pointer) cdecl;
  POBSSourceEnumCallback = ^TOBSSourceEnumCallback;

  POBSSourceAudioMix = ^TOBSSourceAudioMix;
  TOBSSourceAudioMix = record
    Output: Array[0..MAX_AUDIO_MIXES_SOURCE-1] of TOBSAudioOutputData;
  end;

  (*
    Need to import and translate these types!
  *)

  obs_properties_t = Pointer;
  gs_effect_t = Pointer;
  obs_source_frame = Pointer;
  obs_mouse_event = Pointer;
  obs_key_event = Pointer;
  audio_output_data = Pointer;
  obs_missing_files_t = Pointer;
  gs_color_space = Integer;

  POBSSourceInfo = ^TOBSSourceInfo;
  TOBSSourceInfo = record
    Id: PAnsiChar;
	  Typ: TOBSSourceType;
    OutputFlags: Cardinal;
    GetName: TOBSSourceGetNameFunc;
    Create: TOBSSourceCreateFunc;
    Destroy: TOBSSourceDestroyProc;
    GetWidth: TOBSSourceFunc<Cardinal,Pointer>;
    GetHeight: TOBSSourceFunc<Cardinal,Pointer>;
    GetDefaults: TOBSSourceProc<POBSData>;
    GetProperties: TOBSSourceFunc<obs_properties_t,Pointer>;
    Update: TOBSSourceProc2<Pointer,POBSData>;
    Activate: TOBSSourceProc<Pointer>;
    Deactivate: TOBSSourceProc<Pointer>;
    Show: TOBSSourceProc<Pointer>;
    Hide: TOBSSourceProc<Pointer>;
    VideoTick: TOBSSourceProc2<Pointer,Single>;
    VideoRender: TOBSSourceProc2<Pointer,gs_effect_t>;
    FilterVideo: TOBSSourceFunc2<obs_source_frame,Pointer,obs_source_frame>;
    FilterAudio: TOBSSourceFunc2<POBSAudioData,Pointer,POBSAudioData>;
    EnumActiveSources: TOBSSourceProc3<Pointer,TOBSSourceEnumCallback,Pointer>;
    Save: TOBSSourceProc2<Pointer,POBSData>;
    Load: TOBSSourceProc2<Pointer,POBSData>;
    MouseClick: TOBSSourceProc5<Pointer,obs_mouse_event,Integer,Boolean,Cardinal>;
    MouseMove: TOBSSourceProc4<Pointer,obs_mouse_event,Integer,Boolean>;
    MouseWheel: TOBSSourceProc4<Pointer,obs_mouse_event,Integer,Integer>;
    Focus: TOBSSourceProc2<Pointer,Boolean>;
    KeyClick: TOBSSourceProc3<Pointer,obs_key_event,Boolean>;
    FilterRemove: TOBSSourceProc2<Pointer,POBSSource>;
    TypeData: Pointer;
    FreeTypeData: TOBSSourceProc<Pointer>;
    AudioRender: TOBSSourceFunc6<Boolean,Pointer,PUInt64,POBSSourceAudioMix,Cardinal,UInt64,UInt64>;
    EnumAllSources: TOBSSourceProc3<Pointer,TOBSSourceEnumCallback,Pointer>;
    TransitionStart: TOBSSourceProc<Pointer>;
    TransitionStop: TOBSSourceProc<Pointer>;
    GetDefaults2: TOBSSourceProc2<Pointer,POBSData>;
    GetProperties2: TOBSSourceProc2<Pointer,Pointer>;
    AudioMix: TOBSSourceFunc5<Boolean,Pointer,PUInt64,audio_output_data,UInt64,UInt64>;
    IconType: TOBSIconType;
    MediaPlayPause: TOBSSourceProc2<Pointer,Boolean>;
    MediaRestart: TOBSSourceProc<Pointer>;
    MediaStop: TOBSSourceProc<Pointer>;
    MediaNext: TOBSSourceProc<Pointer>;
    MediaPrevious: TOBSSourceProc<Pointer>;
    MediaGetduration: TOBSSourceFunc<UInt64,Pointer>;
    MediaGetTime: TOBSSourceFunc<UInt64,Pointer>;
    MediaSetTime: TOBSSourceProc2<Pointer,UInt64>;
    MediaGetState: TOBSSourceFunc<TOBSMediaState,Pointer>;
    Version: Cardinal;
    UnversionedId: PAnsiChar;
    MissingFiles: TOBSSourceFunc<obs_missing_files_t,Pointer>;
    VideoGetColorSpace: TOBSSourceFunc3<gs_color_space,Pointer,UInt64,^gs_color_space>;
    FilterAdd: TOBSSourceProc2<Pointer,POBSSource>;
  end;

procedure obs_register_source_s(AInfo: POBSSourceInfo; ASize: UInt64); cdecl; external 'obs.dll' name 'obs_register_source_s';

implementation

end.
