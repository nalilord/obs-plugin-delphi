unit XENOME.OBS.Audio;

interface

uses
  XENOME.OBS.Types;

type
  POBSAudioDataArray = ^TOBSAudioDataArray;
  TOBSAudioDataArray = Array[0..MAX_AV_PLANES-1] of Byte;

  POBSAudioOutputDataArray = ^TOBSAudioOutputDataArray;
  TOBSAudioOutputDataArray = Array[0..MAX_AUDIO_CHANNELS-1] of Single;


  POBSAudioData = ^TOBSAudioData;
  TOBSAudioData = record
    Data: POBSAudioDataArray;
    Frames: Cardinal;
    Timestamp: UInt64;
  end;

  TOBSAudioOutputData = record
    Data: POBSAudioOutputDataArray;
  end;

  TOBSAudioInputCallback = reference to function(Param: Pointer; StartTs, EndTs: UInt64; var NewTs: UInt64; ActiveMixers: Cardinal; Mixes: POBSAudioData): Boolean cdecl;
  TOBSAudioOutputCallback = reference to procedure(Param: Pointer; MixIdx: UInt64; Data: POBSAudioData) cdecl;

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

//EXPORT int audio_output_open(audio_t **audio, struct audio_output_info *info);
//EXPORT void audio_output_close(audio_t *audio);

//EXPORT bool audio_output_connect(audio_t *video, size_t mix_idx, const struct audio_convert_info *conversion, audio_output_callback_t callback, void *param);
//EXPORT void audio_output_disconnect(audio_t *video, size_t mix_idx, audio_output_callback_t callback, void *param);

//EXPORT bool audio_output_active(const audio_t *audio);

//EXPORT size_t audio_output_get_block_size(const audio_t *audio);
//EXPORT size_t audio_output_get_planes(const audio_t *audio);
//EXPORT size_t audio_output_get_channels(const audio_t *audio);
//EXPORT uint32_t audio_output_get_sample_rate(const audio_t *audio);
//EXPORT const struct audio_output_info *audio_output_get_info(const audio_t *audio);

implementation

end.
