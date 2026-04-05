# Delphi OBS Bindings

Win64 Delphi/Pascal bindings for OBS/libobs, intended primarily for use from RAD Studio and validated against a local OBS source checkout in [`obs-studio-master`](/mnt/i/Delphi/OBSPlugin/obs-studio-master).

Current release target: `0.1.0`

This repository is being shaped around a pragmatic `0.1` release. The goal is not full libobs coverage. The goal is a stable, documented subset that is useful for real plugins and easy to debug on Win64.

## Status

- Target platform: `Win64` only
- Compiler: `dcc64`
- Primary workflow: open the projects in RAD Studio and build there
- Local helper workflow used during development here: `WSL` invoking the Windows Delphi compiler
- OBS naming is preserved for functions: `obs_*`, `gs_*`, `audio_output_*`, ...
- Delphi naming is used for public types: `TOBS...`, `POBS...`

## Stable 0.1 Surface

The following units are the intended `0.1` working surface:

- [`XENOME.OBS.pas`](/mnt/i/Delphi/OBSPlugin/Source/XENOME.OBS.pas): core libobs entry points, signals/procs/calldata, object helpers, outputs, encoders, services
- [`XENOME.OBS.Source.pas`](/mnt/i/Delphi/OBSPlugin/Source/XENOME.OBS.Source.pas): source registration, source I/O, scenes, scene items, canvases, transitions
- [`XENOME.OBS.Data.pas`](/mnt/i/Delphi/OBSPlugin/Source/XENOME.OBS.Data.pas): `obs_data_*` and `obs_data_array_*`
- [`XENOME.OBS.Properties.pas`](/mnt/i/Delphi/OBSPlugin/Source/XENOME.OBS.Properties.pas): `obs_properties_*` and property-list helpers
- [`XENOME.OBS.Audio.pas`](/mnt/i/Delphi/OBSPlugin/Source/XENOME.OBS.Audio.pas): audio output and raw audio callback surface
- [`XENOME.OBS.Video.pas`](/mnt/i/Delphi/OBSPlugin/Source/XENOME.OBS.Video.pas): video output helpers
- [`XENOME.OBS.Graphics.pas`](/mnt/i/Delphi/OBSPlugin/Source/XENOME.OBS.Graphics.pas): practical `gs_*` runtime/effect/texture/buffer surface
- [`XENOME.OBS.Math.pas`](/mnt/i/Delphi/OBSPlugin/Source/XENOME.OBS.Math.pas): math structs and exported helpers
- [`XENOME.OBS.Types.pas`](/mnt/i/Delphi/OBSPlugin/Source/XENOME.OBS.Types.pas): translated enums/records/constants shared by the units above

## Intentionally Limited

These are intentionally not treated as “stable and complete” for `0.1`:

- full internal libobs record translation
- broad frontend/UI coverage beyond the currently translated practical calls
- complete graphics backend coverage
- cross-platform compatibility

Heavy internal objects such as `TOBSSource` remain opaque unless there is a concrete debugging reason to open them up safely.

## Build

The intended build flow for `0.1` is RAD Studio:

- open [`OBSStatsExport.dpr`](/mnt/i/Delphi/OBSPlugin/Source/OBSStatsExport.dpr)
- open [`OBSDelphiTestPatternPlugin.dpr`](/mnt/i/Delphi/OBSPlugin/Sample/OBSDelphiTestPatternPlugin.dpr)
- open [`OBSDelphiFrontendSmokePlugin.dpr`](/mnt/i/Delphi/OBSPlugin/Sample/OBSDelphiFrontendSmokePlugin.dpr)
- build for `Win64`

## Samples

Current sample/runtime smoke plugins:

- [`OBSDelphiTestPatternPlugin.dpr`](/mnt/i/Delphi/OBSPlugin/Sample/OBSDelphiTestPatternPlugin.dpr)
  Registers `Delphi Test Pattern + Tone`, an async source that generates video and audio.
- [`OBSDelphiFrontendSmokePlugin.dpr`](/mnt/i/Delphi/OBSPlugin/Sample/OBSDelphiFrontendSmokePlugin.dpr)
  Adds a Tools menu item and exercises frontend, global signals, source/output enumeration, and task queue callbacks.

There is also a small utility plugin in [`OBSStatsExport.dpr`](/mnt/i/Delphi/OBSPlugin/Source/OBSStatsExport.dpr) that exercises output statistics and frontend menu wiring.

## Ownership Rules

The most important runtime rule for this binding layer is ownership:

- frontend functions returning `char**` lists return a single owned allocation and must be freed once with `bfree` or the frontend helper wrappers
- frontend functions returning `char*` strings such as the current profile/collection return owned strings and must be freed with `bfree` or the frontend helper wrappers
- frontend functions returning current scene/transition return new source references and must be released with `obs_source_release`
- frontend source lists populated by `obs_frontend_get_scenes` / `obs_frontend_get_transitions` must be released with `obs_frontend_source_list_free`

The frontend helper wrappers for these cases live in [`XENOME.OBS.Frontend.pas`](/mnt/i/Delphi/OBSPlugin/Source/XENOME.OBS.Frontend.pas#L22).

## Recommended Manual Smoke Test

After building and copying the DLLs into your OBS plugin setup:

1. Load `OBSDelphiTestPatternPlugin.dll`.
2. Add the `Delphi Test Pattern + Tone` source.
3. Verify video appears, audio meters move, and changing width/height/frequency works.
4. Load `OBSDelphiFrontendSmokePlugin.dll`.
5. Open the Tools menu and click `Delphi Frontend Smoke`.
6. Rename or remove a source and confirm signal output appears in the plugin console.
7. Optionally load `OBSStatsExport.dll` and confirm its menu item and output-stat hooks still behave.

## Notes

- The bindings are translated against OBS headers first, then validated incrementally by real sample plugins.
- Some debug-oriented records are partially translated on purpose. They are for inspection, not for direct mutation.
- If a declaration exists but has not yet been exercised by a sample, it should be treated as “available, but not broadly runtime-validated”.
