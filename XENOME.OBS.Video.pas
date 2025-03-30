unit XENOME.OBS.Video;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Win.Registry, System.IniFiles, System.Generics.Defaults,
  System.Generics.Collections, System.Contnrs, System.SyncObjs;

const
  MAX_CONVERT_BUFFERS = 3;
  MAX_CACHE_SIZE = 16;
  MAX_AV_PLANES = 8;

{$MINENUMSIZE 4}

type
  TOBSVideoFormat = (
    VIDEO_FORMAT_NONE,
    VIDEO_FORMAT_I420,
    VIDEO_FORMAT_NV12,
    VIDEO_FORMAT_YVYU,
    VIDEO_FORMAT_YUY2,
    VIDEO_FORMAT_UYVY,
    VIDEO_FORMAT_RGBA,
    VIDEO_FORMAT_BGRA,
    VIDEO_FORMAT_BGRX,
    VIDEO_FORMAT_Y800,
    VIDEO_FORMAT_I444,
    VIDEO_FORMAT_BGR3,
    VIDEO_FORMAT_I422,
    VIDEO_FORMAT_I40A,
    VIDEO_FORMAT_I42A,
    VIDEO_FORMAT_YUVA,
    VIDEO_FORMAT_AYUV,
    VIDEO_FORMAT_I010,
    VIDEO_FORMAT_P010,
    VIDEO_FORMAT_I210,
    VIDEO_FORMAT_I412,
    VIDEO_FORMAT_YA2L,
    VIDEO_FORMAT_P216,
    VIDEO_FORMAT_P416,
    VIDEO_FORMAT_V210,
    VIDEO_FORMAT_R10L
  );

  TOBSVideoTRC = (
    VIDEO_TRC_DEFAULT,
    VIDEO_TRC_SRGB,
    VIDEO_TRC_PQ,
    VIDEO_TRC_HLG
  );

  TOBSVideoColorspace = (
    VIDEO_CS_DEFAULT,
    VIDEO_CS_601,
    VIDEO_CS_709,
    VIDEO_CS_SRGB,
    VIDEO_CS_2100_PQ,
    VIDEO_CS_2100_HLG
  );

  TOBSVideoRangeType = (
    VIDEO_RANGE_DEFAULT,
    VIDEO_RANGE_PARTIAL,
    VIDEO_RANGE_FULL
  );

  TOBSVideoscaleType = (
    VIDEO_SCALE_DEFAULT,
    VIDEO_SCALE_POINT,
    VIDEO_SCALE_FAST_BILINEAR,
    VIDEO_SCALE_BILINEAR,
    VIDEO_SCALE_BICUBIC
  );

type
  POBSVideoData = ^TOBSVideoData;
  TOBSVideoData = record // You should NOT use this directly, only translated for debugging purposes!
    Data: Array [0..MAX_AV_PLANES-1] of Pointer;
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
    Inputs: record Arr: Pointer; Num, Capacity: UInt64; end;
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
