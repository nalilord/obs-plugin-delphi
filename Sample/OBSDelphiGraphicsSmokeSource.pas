unit OBSDelphiGraphicsSmokeSource;

interface

uses
  System.SysUtils,
  System.Math,
  XENOME.OBS,
  XENOME.OBS.Types,
  XENOME.OBS.Data,
  XENOME.OBS.Source,
  XENOME.OBS.Graphics,
  XENOME.OBS.Properties;

procedure RegisterOBSDelphiGraphicsSmokeSource;

implementation

const
  GRAPHICS_SOURCE_ID: AnsiString = 'delphi_graphics_smoke_source_v1';
  GRAPHICS_SOURCE_NAME: AnsiString = 'Delphi Graphics Smoke Source';
  SETTING_WIDTH: PAnsiChar = 'width';
  SETTING_HEIGHT: PAnsiChar = 'height';
  SETTING_SPEED: PAnsiChar = 'speed';
  SETTING_ACCENT_COLOR: PAnsiChar = 'accent_color';
  DEFAULT_WIDTH = 640;
  DEFAULT_HEIGHT = 360;
  DEFAULT_SPEED = 45.0;
  DEFAULT_ACCENT_COLOR: Cardinal = $FF4F9DFF;

type
  POBSGraphicsSmokeSource = ^TOBSGraphicsSmokeSource;
  TOBSGraphicsSmokeSource = record
    Width: Cardinal;
    Height: Cardinal;
    SpeedDegPerSecond: Single;
    AccentColor: Cardinal;
    RotationDegrees: Single;
    PulseTime: Single;
  end;

var
  GraphicsSmokeSourceInfo: TOBSSourceInfo;

function ClampInt64(AValue, AMin, AMax: Int64): Cardinal;
begin
  if AValue < AMin then
    AValue:=AMin
  else if AValue > AMax then
    AValue:=AMax;

  Result:=Cardinal(AValue);
end;

function ClampSingle(AValue, AMin, AMax: Single): Single;
begin
  if AValue < AMin then
    Result:=AMin
  else if AValue > AMax then
    Result:=AMax
  else
    Result:=AValue;
end;

function ARGBToVec4(AColor: Cardinal): TOBSVec4;
begin
  Result.X:=((AColor shr 16) and $FF) / 255.0;
  Result.Y:=((AColor shr 8) and $FF) / 255.0;
  Result.Z:=(AColor and $FF) / 255.0;
  Result.W:=((AColor shr 24) and $FF) / 255.0;
end;

function LerpColor(const AFromColor, AToColor: TOBSVec4; AT: Single): TOBSVec4;
begin
  Result.X:=AFromColor.X + ((AToColor.X - AFromColor.X) * AT);
  Result.Y:=AFromColor.Y + ((AToColor.Y - AFromColor.Y) * AT);
  Result.Z:=AFromColor.Z + ((AToColor.Z - AFromColor.Z) * AT);
  Result.W:=AFromColor.W + ((AToColor.W - AFromColor.W) * AT);
end;

procedure DrawSolidRect(ASolidEffect: POBSGSEffect; AColor: Cardinal; AWidth, AHeight: Cardinal);
var
  ColorParam: POBSGSEffectParam;
  Tech: POBSGSTechnique;
  ColorVec: TOBSVec4;
begin
  ColorParam:=gs_effect_get_param_by_name(ASolidEffect, 'color');
  Tech:=gs_effect_get_technique(ASolidEffect, 'Solid');
  if (ColorParam = nil) or (Tech = nil) then
    Exit;

  ColorVec:=ARGBToVec4(AColor);
  gs_effect_set_vec4(ColorParam, @ColorVec);
  gs_technique_begin(Tech);
  gs_technique_begin_pass(Tech, 0);
  gs_draw_sprite(nil, 0, AWidth, AHeight);
  gs_technique_end_pass(Tech);
  gs_technique_end(Tech);
end;

procedure LoadSettings(ASource: POBSGraphicsSmokeSource; ASettings: POBSData);
begin
  if ASettings = nil then
    Exit;

  ASource^.Width:=ClampInt64(obs_data_get_int(ASettings, SETTING_WIDTH), 64, 3840);
  ASource^.Height:=ClampInt64(obs_data_get_int(ASettings, SETTING_HEIGHT), 64, 2160);
  ASource^.SpeedDegPerSecond:=ClampSingle(obs_data_get_double(ASettings, SETTING_SPEED), 0.0, 360.0);
  ASource^.AccentColor:=Cardinal(obs_data_get_int(ASettings, SETTING_ACCENT_COLOR));
end;

function GraphicsSmokeSourceGetName(ATypeData: Pointer): PAnsiChar; cdecl;
begin
  Result:=PAnsiChar(GRAPHICS_SOURCE_NAME);
end;

function GraphicsSmokeSourceCreate(ASettings: POBSData; ASource: POBSSource): Pointer; cdecl;
var
  SourceData: POBSGraphicsSmokeSource;
begin
  New(SourceData);
  FillChar(SourceData^, SizeOf(SourceData^), 0);
  SourceData^.Width:=DEFAULT_WIDTH;
  SourceData^.Height:=DEFAULT_HEIGHT;
  SourceData^.SpeedDegPerSecond:=DEFAULT_SPEED;
  SourceData^.AccentColor:=DEFAULT_ACCENT_COLOR;
  LoadSettings(SourceData, ASettings);
  Result:=SourceData;
end;

procedure GraphicsSmokeSourceDestroy(AData: Pointer); cdecl;
begin
  Dispose(POBSGraphicsSmokeSource(AData));
end;

function GraphicsSmokeSourceGetWidth(AData: Pointer): Cardinal; cdecl;
begin
  Result:=POBSGraphicsSmokeSource(AData)^.Width;
end;

function GraphicsSmokeSourceGetHeight(AData: Pointer): Cardinal; cdecl;
begin
  Result:=POBSGraphicsSmokeSource(AData)^.Height;
end;

procedure GraphicsSmokeSourceGetDefaults(ASettings: POBSData); cdecl;
begin
  obs_data_set_default_int(ASettings, SETTING_WIDTH, DEFAULT_WIDTH);
  obs_data_set_default_int(ASettings, SETTING_HEIGHT, DEFAULT_HEIGHT);
  obs_data_set_default_double(ASettings, SETTING_SPEED, DEFAULT_SPEED);
  obs_data_set_default_int(ASettings, SETTING_ACCENT_COLOR, DEFAULT_ACCENT_COLOR);
end;

function GraphicsSmokeSourceGetProperties(AData: Pointer): POBSProperties; cdecl;
begin
  Result:=obs_properties_create;
  obs_properties_add_int(Result, SETTING_WIDTH, 'Width', 64, 3840, 2);
  obs_properties_add_int(Result, SETTING_HEIGHT, 'Height', 64, 2160, 2);
  obs_properties_add_float_slider(Result, SETTING_SPEED, 'Rotation Speed', 0.0, 360.0, 1.0);
  obs_properties_add_color_alpha(Result, SETTING_ACCENT_COLOR, 'Accent Color');
end;

procedure GraphicsSmokeSourceUpdate(AData: Pointer; ASettings: POBSData); cdecl;
begin
  LoadSettings(POBSGraphicsSmokeSource(AData), ASettings);
end;

procedure GraphicsSmokeSourceVideoTick(AData: Pointer; ASeconds: Single); cdecl;
var
  SourceData: POBSGraphicsSmokeSource;
begin
  SourceData:=POBSGraphicsSmokeSource(AData);
  SourceData^.RotationDegrees:=SourceData^.RotationDegrees + (SourceData^.SpeedDegPerSecond * ASeconds);
  if SourceData^.RotationDegrees >= 360.0 then
    SourceData^.RotationDegrees:=SourceData^.RotationDegrees - 360.0;
  SourceData^.PulseTime:=SourceData^.PulseTime + ASeconds;
end;

procedure GraphicsSmokeSourceVideoRender(AData: Pointer; AEffect: POBSGSEffect); cdecl;
var
  SourceData: POBSGraphicsSmokeSource;
  SolidEffect: POBSGSEffect;
  BackgroundColor: Cardinal;
  AccentVec: TOBSVec4;
  WarmVec: TOBSVec4;
  MixedVec: TOBSVec4;
  Pulse: Single;
  PreviousSrgb: Boolean;
begin
  SourceData:=POBSGraphicsSmokeSource(AData);
  if SourceData = nil then
    Exit;

  SolidEffect:=obs_get_base_effect(OBS_EFFECT_SOLID);
  if SolidEffect = nil then
    Exit;

  PreviousSrgb:=gs_framebuffer_srgb_enabled;
  gs_enable_framebuffer_srgb(True);

  gs_blend_state_push;
  gs_enable_blending(True);

  BackgroundColor:=$FF1B1F2A;
  DrawSolidRect(SolidEffect, BackgroundColor, SourceData^.Width, SourceData^.Height);

  gs_matrix_push;
  try
    gs_matrix_translate3f(SourceData^.Width * 0.5, SourceData^.Height * 0.5, 0.0);
    gs_matrix_rotaa4f(0.0, 0.0, 1.0, DegToRad(SourceData^.RotationDegrees));
    gs_matrix_translate3f(-90.0, -90.0, 0.0);
    DrawSolidRect(SolidEffect, SourceData^.AccentColor, 180, 180);
  finally
    gs_matrix_pop;
  end;

  AccentVec:=ARGBToVec4(SourceData^.AccentColor);
  WarmVec:=ARGBToVec4($FFE86F51);
  Pulse:=(Sin(SourceData^.PulseTime * 2.0) + 1.0) * 0.5;
  MixedVec:=LerpColor(AccentVec, WarmVec, Pulse);
  MixedVec.W:=0.55;

  gs_matrix_push;
  try
    gs_matrix_translate3f(32.0, SourceData^.Height - 88.0, 0.0);
    DrawSolidRect(SolidEffect,
      (Cardinal(Round(MixedVec.W * 255.0)) shl 24) or
      (Cardinal(Round(MixedVec.X * 255.0)) shl 16) or
      (Cardinal(Round(MixedVec.Y * 255.0)) shl 8) or
      Cardinal(Round(MixedVec.Z * 255.0)),
      SourceData^.Width - 64, 56);
  finally
    gs_matrix_pop;
  end;

  gs_blend_state_pop;
  gs_enable_framebuffer_srgb(PreviousSrgb);
end;

procedure RegisterOBSDelphiGraphicsSmokeSource;
begin
  FillChar(GraphicsSmokeSourceInfo, SizeOf(GraphicsSmokeSourceInfo), 0);
  GraphicsSmokeSourceInfo.Id:=PAnsiChar(GRAPHICS_SOURCE_ID);
  GraphicsSmokeSourceInfo.Typ:=OBS_SOURCE_TYPE_INPUT;
  GraphicsSmokeSourceInfo.OutputFlags:=OBS_SOURCE_VIDEO or OBS_SOURCE_CUSTOM_DRAW or OBS_SOURCE_SRGB;
  GraphicsSmokeSourceInfo.GetName:=@GraphicsSmokeSourceGetName;
  GraphicsSmokeSourceInfo.Create:=@GraphicsSmokeSourceCreate;
  GraphicsSmokeSourceInfo.Destroy:=@GraphicsSmokeSourceDestroy;
  GraphicsSmokeSourceInfo.GetWidth:=@GraphicsSmokeSourceGetWidth;
  GraphicsSmokeSourceInfo.GetHeight:=@GraphicsSmokeSourceGetHeight;
  GraphicsSmokeSourceInfo.GetDefaults:=@GraphicsSmokeSourceGetDefaults;
  GraphicsSmokeSourceInfo.GetProperties:=@GraphicsSmokeSourceGetProperties;
  GraphicsSmokeSourceInfo.Update:=@GraphicsSmokeSourceUpdate;
  GraphicsSmokeSourceInfo.VideoTick:=@GraphicsSmokeSourceVideoTick;
  GraphicsSmokeSourceInfo.VideoRender:=@GraphicsSmokeSourceVideoRender;

  obs_register_source_s(@GraphicsSmokeSourceInfo, SizeOf(GraphicsSmokeSourceInfo));
end;

end.
