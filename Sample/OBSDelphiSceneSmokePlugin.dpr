library OBSDelphiSceneSmokePlugin;

uses
  System.SysUtils,
  Winapi.Windows,
  XENOME.OBS in '..\Source\XENOME.OBS.pas',
  XENOME.OBS.Video in '..\Source\XENOME.OBS.Video.pas',
  XENOME.OBS.Frontend in '..\Source\XENOME.OBS.Frontend.pas',
  XENOME.OBS.Source in '..\Source\XENOME.OBS.Source.pas',
  XENOME.OBS.Audio in '..\Source\XENOME.OBS.Audio.pas',
  XENOME.OBS.Data in '..\Source\XENOME.OBS.Data.pas',
  XENOME.OBS.Types in '..\Source\XENOME.OBS.Types.pas',
  XENOME.OBS.Math in '..\Source\XENOME.OBS.Math.pas',
  XENOME.OBS.Graphics in '..\Source\XENOME.OBS.Graphics.pas',
  XENOME.OBS.Properties in '..\Source\XENOME.OBS.Properties.pas',
  XENOME.OBS.Misc in '..\Source\XENOME.OBS.Misc.pas',
  XENOME.OBS.VideoScaler in '..\Source\XENOME.OBS.VideoScaler.pas';

type
  PSceneItemRoundtrip = ^TSceneItemRoundtrip;
  TSceneItemRoundtrip = record
    Item: POBSSceneItem;
    Info: TOBSTransformInfo;
    Crop: TOBSSceneItemCrop;
    Visible: Boolean;
    Locked: Boolean;
    ScaleFilter: TOBSScaleType;
    BlendingMethod: TOBSBlendingMethod;
    BlendingMode: TOBSBlendingType;
  end;

  PSceneItemLogState = ^TSceneItemLogState;
  TSceneItemLogState = record
    Count: Integer;
    FirstItem: POBSSceneItem;
    FirstRoundtrip: TSceneItemRoundtrip;
  end;

var
  Module: POBSModule;

procedure LogLine(const AText: AnsiString);
begin
  WriteLn(String(AText));
end;

function SafeAnsi(AValue: PAnsiChar): AnsiString;
begin
  if AValue <> nil then
    Result:=AnsiString(AValue)
  else
    Result:='<nil>';
end;

function FormatVec2(const AValue: TOBSVec2): AnsiString;
begin
  Result:=AnsiString(Format('(%.2f, %.2f)', [AValue.X, AValue.Y]));
end;

procedure SceneAtomicRoundtrip(AData: Pointer; AScene: POBSScene); cdecl;
var
  Roundtrip: PSceneItemRoundtrip;
begin
  Roundtrip:=PSceneItemRoundtrip(AData);
  if (Roundtrip = nil) or (Roundtrip^.Item = nil) then
    Exit;

  obs_sceneitem_defer_update_begin(Roundtrip^.Item);
  try
    obs_sceneitem_set_info2(Roundtrip^.Item, @Roundtrip^.Info);
    obs_sceneitem_set_crop(Roundtrip^.Item, @Roundtrip^.Crop);
    obs_sceneitem_set_visible(Roundtrip^.Item, Roundtrip^.Visible);
    obs_sceneitem_set_locked(Roundtrip^.Item, Roundtrip^.Locked);
    obs_sceneitem_set_scale_filter(Roundtrip^.Item, Roundtrip^.ScaleFilter);
    obs_sceneitem_set_blending_method(Roundtrip^.Item, Roundtrip^.BlendingMethod);
    obs_sceneitem_set_blending_mode(Roundtrip^.Item, Roundtrip^.BlendingMode);
    obs_sceneitem_force_update_transform(Roundtrip^.Item);
  finally
    obs_sceneitem_defer_update_end(Roundtrip^.Item);
  end;
end;

function EnumSceneItems(AScene: POBSScene; AItem: POBSSceneItem; AParam: Pointer): Boolean; cdecl;
var
  State: PSceneItemLogState;
  ItemSource: POBSSource;
  Pos: TOBSVec2;
  Scale: TOBSVec2;
  Bounds: TOBSVec2;
  Crop: TOBSSceneItemCrop;
begin
  State:=PSceneItemLogState(AParam);
  Inc(State^.Count);

  FillChar(Pos, SizeOf(Pos), 0);
  FillChar(Scale, SizeOf(Scale), 0);
  FillChar(Bounds, SizeOf(Bounds), 0);
  FillChar(Crop, SizeOf(Crop), 0);

  ItemSource:=obs_sceneitem_get_source(AItem);
  obs_sceneitem_get_pos(AItem, @Pos);
  obs_sceneitem_get_scale(AItem, @Scale);
  obs_sceneitem_get_bounds(AItem, @Bounds);
  obs_sceneitem_get_crop(AItem, @Crop);

  LogLine('scene_smoke: item[' + AnsiString(IntToStr(State^.Count)) + '] id=' +
    AnsiString(IntToStr(obs_sceneitem_get_id(AItem))) +
    ' source=' + SafeAnsi(obs_source_get_name(ItemSource)) +
    ' pos=' + FormatVec2(Pos) +
    ' scale=' + FormatVec2(Scale) +
    ' rot=' + AnsiString(Format('%.2f', [obs_sceneitem_get_rot(AItem)])) +
    ' bounds=' + FormatVec2(Bounds) +
    ' visible=' + AnsiString(BoolToStr(obs_sceneitem_visible(AItem), True)) +
    ' locked=' + AnsiString(BoolToStr(obs_sceneitem_locked(AItem), True)) +
    ' crop=(' + AnsiString(IntToStr(Crop.Left)) + ',' +
      AnsiString(IntToStr(Crop.Top)) + ',' +
      AnsiString(IntToStr(Crop.Right)) + ',' +
      AnsiString(IntToStr(Crop.Bottom)) + ')');

  if State^.FirstItem = nil then
  begin
    State^.FirstItem:=AItem;
    obs_sceneitem_addref(AItem);

    FillChar(State^.FirstRoundtrip, SizeOf(State^.FirstRoundtrip), 0);
    State^.FirstRoundtrip.Item:=AItem;
    obs_sceneitem_get_info2(AItem, @State^.FirstRoundtrip.Info);
    obs_sceneitem_get_crop(AItem, @State^.FirstRoundtrip.Crop);
    State^.FirstRoundtrip.Visible:=obs_sceneitem_visible(AItem);
    State^.FirstRoundtrip.Locked:=obs_sceneitem_locked(AItem);
    State^.FirstRoundtrip.ScaleFilter:=obs_sceneitem_get_scale_filter(AItem);
    State^.FirstRoundtrip.BlendingMethod:=obs_sceneitem_get_blending_method(AItem);
    State^.FirstRoundtrip.BlendingMode:=obs_sceneitem_get_blending_mode(AItem);
  end;

  Result:=True;
end;

procedure SceneSmokeToolsMenu(APrivateData: Pointer); cdecl;
var
  CurrentSceneSource: POBSSource;
  CurrentScene: POBSScene;
  State: TSceneItemLogState;
begin
  FillChar(State, SizeOf(State), 0);
  CurrentSceneSource:=obs_frontend_get_current_scene;
  if CurrentSceneSource = nil then
  begin
    LogLine('scene_smoke: no current scene');
    Exit;
  end;

  try
    CurrentScene:=obs_scene_from_source(CurrentSceneSource);
    if CurrentScene = nil then
    begin
      LogLine('scene_smoke: current source is not a scene');
      Exit;
    end;

    LogLine('scene_smoke: current_scene=' + SafeAnsi(obs_source_get_name(CurrentSceneSource)));
    obs_scene_enum_items(CurrentScene, @EnumSceneItems, @State);
    LogLine('scene_smoke: item_count=' + AnsiString(IntToStr(State.Count)));

    if State.FirstItem <> nil then
    begin
      obs_scene_atomic_update(CurrentScene, @SceneAtomicRoundtrip, @State.FirstRoundtrip);
      LogLine('scene_smoke: first item roundtrip update applied');
    end;
  finally
    if State.FirstItem <> nil then
      obs_sceneitem_release(State.FirstItem);
    obs_source_release(CurrentSceneSource);
  end;
end;

procedure obs_module_set_pointer(AModule: POBSModule); cdecl;
begin
  Module:=AModule;
end;

function obs_current_module: POBSModule; cdecl;
begin
  Result:=Module;
end;

function obs_module_ver: Cardinal;
begin
  Result:=LIBOBS_API_VER;
end;

function obs_module_load: Boolean; cdecl;
begin
  obs_frontend_add_tools_menu_item('Delphi Scene Smoke', @SceneSmokeToolsMenu, nil);
  LogLine('scene_smoke: loaded');
  Result:=True;
end;

procedure obs_module_unload; cdecl;
begin
end;

function obs_module_author: PAnsiChar; cdecl;
begin
  Result:='NaliLord';
end;

function obs_module_name: PAnsiChar; cdecl;
begin
  Result:='OBS Delphi Scene Smoke';
end;

function obs_module_description: PAnsiChar; cdecl;
begin
  Result:='Scene and scene-item smoke test for the Delphi OBS bindings.';
end;

exports
  obs_module_set_pointer,
  obs_current_module,
  obs_module_ver,
  obs_module_load,
  obs_module_unload,
  obs_module_author,
  obs_module_name,
  obs_module_description;

begin
  AllocConsole;
end.
