unit XENOME.OBS.Video;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Win.Registry, System.IniFiles, System.Generics.Defaults,
  System.Generics.Collections, System.Contnrs, System.SyncObjs, XENOME.OBS.Types;

type
  POBSVideoDataArray = ^TOBSVideoDataArray;
  TOBSVideoDataArray = Array[0..MAX_AV_PLANES-1] of Byte;

  POBSVideoData = ^TOBSVideoData;
  TOBSVideoData = record // You should NOT use this directly, only translated for debugging purposes!
    Data: POBSVideoDataArray;
    LineSize: Array [0..MAX_AV_PLANES-1] of Cardinal;
    TimeStamp: UInt64;
  end;

  POBSCachedFrameInfo = ^TOBSCachedFrameInfo;
  TOBSCachedFrameInfo = record // You should NOT use this directly, only translated for debugging purposes!
    Frame: TOBSVideoData;
    Skipped: Integer;
    Count: Integer;
  end;

  POBSVideoOutputInfo = ^TOBSVideoOutputInfo;
  TOBSVideoOutputInfo = record // You should NOT use this directly, only translated for debugging purposes!
    Name: PAnsiChar;
    Format: TOBSVideoFormat;
    FPSNum: Cardinal;
    FPSDen: Cardinal;
    Width: Cardinal;
    Height: Cardinal;
    CacheSize: UInt64;
    Colorspace: TOBSVideoColorspace;
    Range: TOBSVideoRangeType;
  end;

  POBSVideoOutput = ^TOBSVideoOutput;
  TOBSVideoOutput = record // You should NOT use this directly, only translated for debugging purposes!
    Info: TOBSVideoOutputInfo;
    Thread: Array[0..15] of Byte;
    DataMutex: Pointer;
    Stop: Boolean;
    UpdateSemaphore: Pointer;
    FrameTime: UInt64;
    [volatile] SkippedFrames: Cardinal;
    [volatile] TotalFrames: Cardinal;
    InputMutex: Pointer;
    Inputs: TOBSDArray;
    AvailableFrames: UInt64;
    FirstAdded: UInt64;
    LastAdded: UInt64;
    Cache: Array[0..MAX_CACHE_SIZE-1] of TOBSCachedFrameInfo;
    Parent: POBSVideoOutput;
    [volatile] RawActive: Boolean;
    [volatile] GpuRefs: Cardinal;
  end;

  POBSVideoScaleInfo = ^TOBSVideoScaleInfo;
  TOBSVideoScaleInfo = record
    Format: TOBSVideoFormat;
    Width: Cardinal;
    Height: Cardinal;
    Range: TOBSVideoRangeType;
    Colorspace: TOBSVideoColorspace;
  end;

  POBSVideoInfo = ^TOBSVideoInfo;
  TOBSVideoInfo = record
    GraphicsModule: PAnsiChar;
    FPSNum: Cardinal;
    FPSDen: Cardinal;
    BaseWidth: Cardinal;
    BaseHeight: Cardinal;
    OutputWidth: Cardinal;
    OutputHeight: Cardinal;
    OutputFormat: TOBSVideoFormat;
    Adapter: Cardinal;
    GPUConversion: Boolean;
    Colorspace: TOBSVideoColorspace;
    Range: TOBSVideoRangeType;
    ScaleType: TOBSVideoScaleType
  end;

function obs_get_video: POBSVideoOutput; cdecl; external 'obs.dll' name 'obs_get_video';
function video_output_active(AVideo: POBSVideoOutput): Boolean; cdecl; external 'obs.dll' name 'video_output_active';
function video_output_get_info(AVideo: POBSVideoOutput): POBSVideoOutputInfo; cdecl; external 'obs.dll' name 'video_output_get_info';
function video_output_get_frame_time(AVideo: POBSVideoOutput): UInt64; cdecl; external 'obs.dll' name 'video_output_get_frame_time';
function video_output_get_format(const AVideo: POBSVideoOutput): TOBSVideoFormat; cdecl; external 'obs.dll' name 'video_output_get_format';
function video_output_get_width(const AVideo: POBSVideoOutput): Cardinal; cdecl; external 'obs.dll' name 'video_output_get_width';
function video_output_get_height(const AVideo: POBSVideoOutput): Cardinal; cdecl; external 'obs.dll' name 'video_output_get_height';
function video_output_get_frame_rate(const AVideo: POBSVideoOutput): Single; cdecl; external 'obs.dll' name 'video_output_get_frame_rate';
function video_output_get_skipped_frames(const AVideo: POBSVideoOutput): Cardinal; cdecl; external 'obs.dll' name 'video_output_get_skipped_frames';
function video_output_get_total_frames(const AVideo: POBSVideoOutput): Cardinal; cdecl; external 'obs.dll' name 'video_output_get_total_frames';

implementation

end.
