unit XENOME.OBS.Audio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Win.Registry, System.IniFiles, System.Generics.Defaults, System.Generics.Collections,
  System.Contnrs, System.SyncObjs, XENOME.OBS, XENOME.OBS.Types;

type
  POBSAudioData = ^TOBSAudioData;
  TOBSAudioData = record
    Data: Array[0..MAX_AV_PLANES-1] of PByte;
    Frames: Cardinal;
    Timestamp: UInt64;
  end;

  POBSAudioOutputData = ^TOBSAudioOutputData;
  TOBSAudioOutputData = record
    Data: Array[0..MAX_AUDIO_CHANNELS-1] of PSingle;
  end;

  TOBSAudioInputCallback = function(Param: Pointer; StartTs, EndTs: UInt64; var NewTs: UInt64; ActiveMixers: Cardinal; Mixes: POBSAudioOutputData): Boolean cdecl;
  TOBSAudioOutputCallback = procedure(Param: Pointer; MixIdx: NativeUInt; Data: POBSAudioData) cdecl;

  POBSAudioOutputInfo = ^TOBSAudioOutputInfo;
  TOBSAudioOutputInfo = record
    Name: PAnsiChar;
    SamplesPerSec: Cardinal;
    Format: TOBSAudioFormat;
    Speakers: TOBSSpeakerLayout;
    InputCallback: TOBSAudioInputCallback;
    InputParam: Pointer;
  end;

  POBSAudioConvertInfo = ^TOBSAudioConvertInfo;
  TOBSAudioConvertInfo = record
    SamplesPerSec: Cardinal;
    Format: TOBSAudioFormat;
    Speakers: TOBSSpeakerLayout;
    AllowClipping: Boolean;
  end;

function audio_output_open(out AAudio: POBSAudio; AInfo: POBSAudioOutputInfo): Integer; cdecl; external 'obs.dll' name 'audio_output_open';
procedure audio_output_close(AAudio: POBSAudio); cdecl; external 'obs.dll' name 'audio_output_close';

function audio_output_connect(AAudio: POBSAudio; AMixIdx: NativeUInt; AConversion: POBSAudioConvertInfo; ACallback: TOBSAudioOutputCallback; AParam: Pointer): Boolean; cdecl; external 'obs.dll' name 'audio_output_connect';
procedure audio_output_disconnect(AAudio: POBSAudio; AMixIdx: NativeUInt; ACallback: TOBSAudioOutputCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'audio_output_disconnect';

function audio_output_active(const AAudio: POBSAudio): Boolean; cdecl; external 'obs.dll' name 'audio_output_active';

function audio_output_get_block_size(const AAudio: POBSAudio): NativeUInt; cdecl; external 'obs.dll' name 'audio_output_get_block_size';
function audio_output_get_planes(const AAudio: POBSAudio): NativeUInt; cdecl; external 'obs.dll' name 'audio_output_get_planes';
function audio_output_get_channels(const AAudio: POBSAudio): NativeUInt; cdecl; external 'obs.dll' name 'audio_output_get_channels';
function audio_output_get_sample_rate(const AAudio: POBSAudio): Cardinal; cdecl; external 'obs.dll' name 'audio_output_get_sample_rate';
function audio_output_get_info(const AAudio: POBSAudio): POBSAudioOutputInfo; cdecl; external 'obs.dll' name 'audio_output_get_info';

procedure obs_add_raw_audio_callback(AMixIdx: NativeUInt; AConversion: POBSAudioConvertInfo; ACallback: TOBSAudioOutputCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_add_raw_audio_callback';
procedure obs_remove_raw_audio_callback(AMixIdx: NativeUInt; ACallback: TOBSAudioOutputCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_remove_raw_audio_callback';

implementation

end.
