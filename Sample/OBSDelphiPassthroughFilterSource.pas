unit OBSDelphiPassthroughFilterSource;

interface

uses
  System.SysUtils,
  XENOME.OBS,
  XENOME.OBS.Types,
  XENOME.OBS.Data,
  XENOME.OBS.Source,
  XENOME.OBS.Graphics;

procedure RegisterOBSDelphiPassthroughFilterSource;

implementation

type
  POBSDelphiPassthroughFilterData = ^TOBSDelphiPassthroughFilterData;
  TOBSDelphiPassthroughFilterData = record
    Source: POBSSource;
  end;

var
  PassthroughFilterInfo: TOBSSourceInfo;

function OBSDelphiPassthroughFilterGetName(TypeData: Pointer): PAnsiChar; cdecl;
begin
  Result:='Delphi Passthrough Filter';
end;

function OBSDelphiPassthroughFilterCreate(Settings: POBSData; Source: POBSSource): Pointer; cdecl;
var
  FilterData: POBSDelphiPassthroughFilterData;
begin
  New(FilterData);
  FilterData.Source:=Source;
  Result:=FilterData;
end;

procedure OBSDelphiPassthroughFilterDestroy(Data: Pointer); cdecl;
begin
  Dispose(POBSDelphiPassthroughFilterData(Data));
end;

function OBSDelphiPassthroughFilterGetWidth(Data: Pointer): Cardinal; cdecl;
var
  Target: POBSSource;
  FilterData: POBSDelphiPassthroughFilterData;
begin
  FilterData:=POBSDelphiPassthroughFilterData(Data);
  if (FilterData = nil) or (FilterData.Source = nil) then
    Exit(0);

  Target:=obs_filter_get_target(FilterData.Source);
  if Target = nil then
    Exit(0);

  Result:=obs_source_get_base_width(Target);
  if Result = 0 then
    Result:=obs_source_get_width(Target);
end;

function OBSDelphiPassthroughFilterGetHeight(Data: Pointer): Cardinal; cdecl;
var
  Target: POBSSource;
  FilterData: POBSDelphiPassthroughFilterData;
begin
  FilterData:=POBSDelphiPassthroughFilterData(Data);
  if (FilterData = nil) or (FilterData.Source = nil) then
    Exit(0);

  Target:=obs_filter_get_target(FilterData.Source);
  if Target = nil then
    Exit(0);

  Result:=obs_source_get_base_height(Target);
  if Result = 0 then
    Result:=obs_source_get_height(Target);
end;

procedure OBSDelphiPassthroughFilterVideoRender(Data: Pointer; Effect: POBSGSEffect); cdecl;
var
  FilterData: POBSDelphiPassthroughFilterData;
  Width: Cardinal;
  Height: Cardinal;
  BaseEffect: POBSGSEffect;
begin
  FilterData:=POBSDelphiPassthroughFilterData(Data);
  if (FilterData = nil) or (FilterData.Source = nil) then
    Exit;

  Width:=OBSDelphiPassthroughFilterGetWidth(Data);
  Height:=OBSDelphiPassthroughFilterGetHeight(Data);
  if (Width = 0) or (Height = 0) then
  begin
    obs_source_skip_video_filter(FilterData.Source);
    Exit;
  end;

  if not obs_source_process_filter_begin(FilterData.Source, GS_RGBA, OBS_ALLOW_DIRECT_RENDERING) then
  begin
    obs_source_skip_video_filter(FilterData.Source);
    Exit;
  end;

  BaseEffect:=obs_get_base_effect(OBS_EFFECT_DEFAULT);
  obs_source_process_filter_end(FilterData.Source, BaseEffect, Width, Height);
end;

procedure RegisterOBSDelphiPassthroughFilterSource;
begin
  FillChar(PassthroughFilterInfo, SizeOf(PassthroughFilterInfo), 0);
  PassthroughFilterInfo.Id:='delphi_passthrough_filter_v1';
  PassthroughFilterInfo.Typ:=OBS_SOURCE_TYPE_FILTER;
  PassthroughFilterInfo.OutputFlags:=OBS_SOURCE_VIDEO;
  PassthroughFilterInfo.GetName:=@OBSDelphiPassthroughFilterGetName;
  PassthroughFilterInfo.Create:=@OBSDelphiPassthroughFilterCreate;
  PassthroughFilterInfo.Destroy:=@OBSDelphiPassthroughFilterDestroy;
  PassthroughFilterInfo.GetWidth:=@OBSDelphiPassthroughFilterGetWidth;
  PassthroughFilterInfo.GetHeight:=@OBSDelphiPassthroughFilterGetHeight;
  PassthroughFilterInfo.VideoRender:=@OBSDelphiPassthroughFilterVideoRender;

  obs_register_source(@PassthroughFilterInfo);
end;

end.
