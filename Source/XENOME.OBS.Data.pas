unit XENOME.OBS.Data;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Win.Registry, System.IniFiles, System.Generics.Defaults, System.Generics.Collections,
  System.Contnrs, System.SyncObjs, XENOME.OBS.Types, XENOME.OBS.Misc;

type
  POBSData = ^TOBSData;
  POBSDataItem = ^TOBSDataItem;
  PPOBSDataItem = ^POBSDataItem;
  TOBSDataArrayEnumProc = procedure(AData: POBSData; AParam: Pointer) cdecl;

  TOBSDataItem = record
    [volatile] Ref: Cardinal;
    Name: PAnsiChar;
    Parent: POBSData;
    HashHandle: UT_hash_handle;
    Typ: TOBSDataType;
    NameLen: UInt64;
    DataLen: UInt64;
    DataSize: UInt64;
    DefaultLen: UInt64;
    DefaultSize: UInt64;
    AutoselectSize: UInt64;
    Capacity: UInt64;
  end;

  TOBSData = record
    [volatile] Ref: Cardinal;
    Json: PAnsiChar;
    Items: POBSDataItem;
  end;

  POBSDataArray = ^TOBSDataArray;
  TOBSDataArray = record
    [volatile] Ref: Cardinal;
    Objects: TOBSDArray<POBSData>;
  end;

  POBSDataNumber = ^TOBSDataNumber;
  TOBSDataNumber = record
    Typ: TOBSDataNumberType;
    case Integer of
      0: (
        IntVal: Int64;
      );
      1: (
        DoubleVal: Double;
      );
  end;

function obs_data_create: POBSData; cdecl; external 'obs.dll' name 'obs_data_create';
function obs_data_create_from_json(AJson: PAnsiChar): POBSData; cdecl; external 'obs.dll' name 'obs_data_create_from_json';
procedure obs_data_addref(AData: POBSData); cdecl; external 'obs.dll' name 'obs_data_addref';
procedure obs_data_release(AData: POBSData); cdecl; external 'obs.dll' name 'obs_data_release';
function obs_data_get_json(AData: POBSData): PAnsiChar; cdecl; external 'obs.dll' name 'obs_data_get_json';
function obs_data_get_json_with_defaults(AData: POBSData): PAnsiChar; cdecl; external 'obs.dll' name 'obs_data_get_json_with_defaults';
function obs_data_get_json_pretty(AData: POBSData): PAnsiChar; cdecl; external 'obs.dll' name 'obs_data_get_json_pretty';
function obs_data_get_json_pretty_with_defaults(AData: POBSData): PAnsiChar; cdecl; external 'obs.dll' name 'obs_data_get_json_pretty_with_defaults';
function obs_data_get_last_json(AData: POBSData): PAnsiChar; cdecl; external 'obs.dll' name 'obs_data_get_last_json';
procedure obs_data_apply(ATarget, AApplyData: POBSData); cdecl; external 'obs.dll' name 'obs_data_apply';
procedure obs_data_erase(AData: POBSData; AName: PAnsiChar); cdecl; external 'obs.dll' name 'obs_data_erase';
procedure obs_data_clear(AData: POBSData); cdecl; external 'obs.dll' name 'obs_data_clear';
procedure obs_data_set_string(AData: POBSData; AName, AValue: PAnsiChar); cdecl; external 'obs.dll' name 'obs_data_set_string';
procedure obs_data_set_int(AData: POBSData; AName: PAnsiChar; AValue: Int64); cdecl; external 'obs.dll' name 'obs_data_set_int';
procedure obs_data_set_double(AData: POBSData; AName: PAnsiChar; AValue: Double); cdecl; external 'obs.dll' name 'obs_data_set_double';
procedure obs_data_set_bool(AData: POBSData; AName: PAnsiChar; AValue: Boolean); cdecl; external 'obs.dll' name 'obs_data_set_bool';
procedure obs_data_set_obj(AData: POBSData; AName: PAnsiChar; AValue: POBSData); cdecl; external 'obs.dll' name 'obs_data_set_obj';
procedure obs_data_set_array(AData: POBSData; AName: PAnsiChar; AValue: POBSDataArray); cdecl; external 'obs.dll' name 'obs_data_set_array';
function obs_data_get_defaults(AData: POBSData): POBSData; cdecl; external 'obs.dll' name 'obs_data_get_defaults';
procedure obs_data_set_default_string(AData: POBSData; AName, AValue: PAnsiChar); cdecl; external 'obs.dll' name 'obs_data_set_default_string';
procedure obs_data_set_default_int(AData: POBSData; AName: PAnsiChar; AValue: Int64); cdecl; external 'obs.dll' name 'obs_data_set_default_int';
procedure obs_data_set_default_double(AData: POBSData; AName: PAnsiChar; AValue: Double); cdecl; external 'obs.dll' name 'obs_data_set_default_double';
procedure obs_data_set_default_bool(AData: POBSData; AName: PAnsiChar; AValue: Boolean); cdecl; external 'obs.dll' name 'obs_data_set_default_bool';
procedure obs_data_set_default_obj(AData: POBSData; AName: PAnsiChar; AValue: POBSData); cdecl; external 'obs.dll' name 'obs_data_set_default_obj';
procedure obs_data_set_default_array(AData: POBSData; AName: PAnsiChar; AValue: POBSDataArray); cdecl; external 'obs.dll' name 'obs_data_set_default_array';
procedure obs_data_set_autoselect_string(AData: POBSData; AName, AValue: PAnsiChar); cdecl; external 'obs.dll' name 'obs_data_set_autoselect_string';
procedure obs_data_set_autoselect_int(AData: POBSData; AName: PAnsiChar; AValue: Int64); cdecl; external 'obs.dll' name 'obs_data_set_autoselect_int';
procedure obs_data_set_autoselect_double(AData: POBSData; AName: PAnsiChar; AValue: Double); cdecl; external 'obs.dll' name 'obs_data_set_autoselect_double';
procedure obs_data_set_autoselect_bool(AData: POBSData; AName: PAnsiChar; AValue: Boolean); cdecl; external 'obs.dll' name 'obs_data_set_autoselect_bool';
procedure obs_data_set_autoselect_obj(AData: POBSData; AName: PAnsiChar; AValue: POBSData); cdecl; external 'obs.dll' name 'obs_data_set_autoselect_obj';
procedure obs_data_set_autoselect_array(AData: POBSData; AName: PAnsiChar; AValue: POBSDataArray); cdecl; external 'obs.dll' name 'obs_data_set_autoselect_array';
function obs_data_get_string(AData: POBSData; AName: PAnsiChar): PAnsiChar; cdecl; external 'obs.dll' name 'obs_data_get_string';
function obs_data_get_int(AData: POBSData; AName: PAnsiChar): Int64; cdecl; external 'obs.dll' name 'obs_data_get_int';
function obs_data_get_double(AData: POBSData; AName: PAnsiChar): Double; cdecl; external 'obs.dll' name 'obs_data_get_double';
function obs_data_get_bool(AData: POBSData; AName: PAnsiChar): Boolean; cdecl; external 'obs.dll' name 'obs_data_get_bool';
function obs_data_get_obj(AData: POBSData; AName: PAnsiChar): POBSData; cdecl; external 'obs.dll' name 'obs_data_get_obj';
function obs_data_get_array(AData: POBSData; AName: PAnsiChar): POBSDataArray; cdecl; external 'obs.dll' name 'obs_data_get_array';
function obs_data_get_default_string(AData: POBSData; AName: PAnsiChar): PAnsiChar; cdecl; external 'obs.dll' name 'obs_data_get_default_string';
function obs_data_get_default_int(AData: POBSData; AName: PAnsiChar): Int64; cdecl; external 'obs.dll' name 'obs_data_get_default_int';
function obs_data_get_default_double(AData: POBSData; AName: PAnsiChar): Double; cdecl; external 'obs.dll' name 'obs_data_get_default_double';
function obs_data_get_default_bool(AData: POBSData; AName: PAnsiChar): Boolean; cdecl; external 'obs.dll' name 'obs_data_get_default_bool';
function obs_data_get_default_obj(AData: POBSData; AName: PAnsiChar): POBSData; cdecl; external 'obs.dll' name 'obs_data_get_default_obj';
function obs_data_get_default_array(AData: POBSData; AName: PAnsiChar): POBSDataArray; cdecl; external 'obs.dll' name 'obs_data_get_default_array';
function obs_data_get_autoselect_string(AData: POBSData; AName: PAnsiChar): PAnsiChar; cdecl; external 'obs.dll' name 'obs_data_get_autoselect_string';
function obs_data_get_autoselect_int(AData: POBSData; AName: PAnsiChar): Int64; cdecl; external 'obs.dll' name 'obs_data_get_autoselect_int';
function obs_data_get_autoselect_double(AData: POBSData; AName: PAnsiChar): Double; cdecl; external 'obs.dll' name 'obs_data_get_autoselect_double';
function obs_data_get_autoselect_bool(AData: POBSData; AName: PAnsiChar): Boolean; cdecl; external 'obs.dll' name 'obs_data_get_autoselect_bool';
function obs_data_get_autoselect_obj(AData: POBSData; AName: PAnsiChar): POBSData; cdecl; external 'obs.dll' name 'obs_data_get_autoselect_obj';
function obs_data_get_autoselect_array(AData: POBSData; AName: PAnsiChar): POBSDataArray; cdecl; external 'obs.dll' name 'obs_data_get_autoselect_array';
function obs_data_array_create: POBSDataArray; cdecl; external 'obs.dll' name 'obs_data_array_create';
procedure obs_data_array_addref(AArray: POBSDataArray); cdecl; external 'obs.dll' name 'obs_data_array_addref';
procedure obs_data_array_release(AArray: POBSDataArray); cdecl; external 'obs.dll' name 'obs_data_array_release';
function obs_data_array_count(AArray: POBSDataArray): NativeUInt; cdecl; external 'obs.dll' name 'obs_data_array_count';
function obs_data_array_item(AArray: POBSDataArray; AIndex: NativeUInt): POBSData; cdecl; external 'obs.dll' name 'obs_data_array_item';
function obs_data_array_push_back(AArray: POBSDataArray; AObject: POBSData): NativeUInt; cdecl; external 'obs.dll' name 'obs_data_array_push_back';
procedure obs_data_array_insert(AArray: POBSDataArray; AIndex: NativeUInt; AObject: POBSData); cdecl; external 'obs.dll' name 'obs_data_array_insert';
procedure obs_data_array_push_back_array(AArray, AArray2: POBSDataArray); cdecl; external 'obs.dll' name 'obs_data_array_push_back_array';
procedure obs_data_array_erase(AArray: POBSDataArray; AIndex: NativeUInt); cdecl; external 'obs.dll' name 'obs_data_array_erase';
procedure obs_data_array_enum(AArray: POBSDataArray; ACallback: TOBSDataArrayEnumProc; AParam: Pointer); cdecl; external 'obs.dll' name 'obs_data_array_enum';
function obs_data_has_user_value(AData: POBSData; AName: PAnsiChar): Boolean; cdecl; external 'obs.dll' name 'obs_data_has_user_value';
function obs_data_has_default_value(AData: POBSData; AName: PAnsiChar): Boolean; cdecl; external 'obs.dll' name 'obs_data_has_default_value';
function obs_data_has_autoselect_value(AData: POBSData; AName: PAnsiChar): Boolean; cdecl; external 'obs.dll' name 'obs_data_has_autoselect_value';
function obs_data_item_has_user_value(AItem: POBSDataItem): Boolean; cdecl; external 'obs.dll' name 'obs_data_item_has_user_value';
function obs_data_item_has_default_value(AItem: POBSDataItem): Boolean; cdecl; external 'obs.dll' name 'obs_data_item_has_default_value';
function obs_data_item_has_autoselect_value(AItem: POBSDataItem): Boolean; cdecl; external 'obs.dll' name 'obs_data_item_has_autoselect_value';
procedure obs_data_unset_user_value(AData: POBSData; AName: PAnsiChar); cdecl; external 'obs.dll' name 'obs_data_unset_user_value';
procedure obs_data_unset_default_value(AData: POBSData; AName: PAnsiChar); cdecl; external 'obs.dll' name 'obs_data_unset_default_value';
procedure obs_data_unset_autoselect_value(AData: POBSData; AName: PAnsiChar); cdecl; external 'obs.dll' name 'obs_data_unset_autoselect_value';
procedure obs_data_item_unset_user_value(AItem: POBSDataItem); cdecl; external 'obs.dll' name 'obs_data_item_unset_user_value';
procedure obs_data_item_unset_default_value(AItem: POBSDataItem); cdecl; external 'obs.dll' name 'obs_data_item_unset_default_value';
procedure obs_data_item_unset_autoselect_value(AItem: POBSDataItem); cdecl; external 'obs.dll' name 'obs_data_item_unset_autoselect_value';
function obs_data_first(AData: POBSData): POBSDataItem; cdecl; external 'obs.dll' name 'obs_data_first';
function obs_data_item_byname(AData: POBSData; AName: PAnsiChar): POBSDataItem; cdecl; external 'obs.dll' name 'obs_data_item_byname';
function obs_data_item_next(AItem: PPOBSDataItem): Boolean; cdecl; external 'obs.dll' name 'obs_data_item_next';
procedure obs_data_item_release(AItem: PPOBSDataItem); cdecl; external 'obs.dll' name 'obs_data_item_release';
procedure obs_data_item_remove(AItem: PPOBSDataItem); cdecl; external 'obs.dll' name 'obs_data_item_remove';
function obs_data_item_gettype(AItem: POBSDataItem): TOBSDataType; cdecl; external 'obs.dll' name 'obs_data_item_gettype';
function obs_data_item_numtype(AItem: POBSDataItem): TOBSDataNumberType; cdecl; external 'obs.dll' name 'obs_data_item_numtype';
function obs_data_item_get_name(AItem: POBSDataItem): PAnsiChar; cdecl; external 'obs.dll' name 'obs_data_item_get_name';
function obs_data_item_get_string(AItem: POBSDataItem): PAnsiChar; cdecl; external 'obs.dll' name 'obs_data_item_get_string';
function obs_data_item_get_int(AItem: POBSDataItem): Int64; cdecl; external 'obs.dll' name 'obs_data_item_get_int';
function obs_data_item_get_double(AItem: POBSDataItem): Double; cdecl; external 'obs.dll' name 'obs_data_item_get_double';
function obs_data_item_get_bool(AItem: POBSDataItem): Boolean; cdecl; external 'obs.dll' name 'obs_data_item_get_bool';
function obs_data_item_get_obj(AItem: POBSDataItem): POBSData; cdecl; external 'obs.dll' name 'obs_data_item_get_obj';
function obs_data_item_get_array(AItem: POBSDataItem): POBSDataArray; cdecl; external 'obs.dll' name 'obs_data_item_get_array';
procedure obs_data_item_set_string(AItem: PPOBSDataItem; AValue: PAnsiChar); cdecl; external 'obs.dll' name 'obs_data_item_set_string';
procedure obs_data_item_set_int(AItem: PPOBSDataItem; AValue: Int64); cdecl; external 'obs.dll' name 'obs_data_item_set_int';
procedure obs_data_item_set_double(AItem: PPOBSDataItem; AValue: Double); cdecl; external 'obs.dll' name 'obs_data_item_set_double';
procedure obs_data_item_set_bool(AItem: PPOBSDataItem; AValue: Boolean); cdecl; external 'obs.dll' name 'obs_data_item_set_bool';
procedure obs_data_item_set_obj(AItem: PPOBSDataItem; AValue: POBSData); cdecl; external 'obs.dll' name 'obs_data_item_set_obj';
procedure obs_data_item_set_array(AItem: PPOBSDataItem; AValue: POBSDataArray); cdecl; external 'obs.dll' name 'obs_data_item_set_array';
procedure obs_data_item_set_default_string(AItem: PPOBSDataItem; AValue: PAnsiChar); cdecl; external 'obs.dll' name 'obs_data_item_set_default_string';
procedure obs_data_item_set_default_int(AItem: PPOBSDataItem; AValue: Int64); cdecl; external 'obs.dll' name 'obs_data_item_set_default_int';
procedure obs_data_item_set_default_double(AItem: PPOBSDataItem; AValue: Double); cdecl; external 'obs.dll' name 'obs_data_item_set_default_double';
procedure obs_data_item_set_default_bool(AItem: PPOBSDataItem; AValue: Boolean); cdecl; external 'obs.dll' name 'obs_data_item_set_default_bool';
procedure obs_data_item_set_default_obj(AItem: PPOBSDataItem; AValue: POBSData); cdecl; external 'obs.dll' name 'obs_data_item_set_default_obj';
procedure obs_data_item_set_default_array(AItem: PPOBSDataItem; AValue: POBSDataArray); cdecl; external 'obs.dll' name 'obs_data_item_set_default_array';
procedure obs_data_item_set_autoselect_string(AItem: PPOBSDataItem; AValue: PAnsiChar); cdecl; external 'obs.dll' name 'obs_data_item_set_autoselect_string';
procedure obs_data_item_set_autoselect_int(AItem: PPOBSDataItem; AValue: Int64); cdecl; external 'obs.dll' name 'obs_data_item_set_autoselect_int';
procedure obs_data_item_set_autoselect_double(AItem: PPOBSDataItem; AValue: Double); cdecl; external 'obs.dll' name 'obs_data_item_set_autoselect_double';
procedure obs_data_item_set_autoselect_bool(AItem: PPOBSDataItem; AValue: Boolean); cdecl; external 'obs.dll' name 'obs_data_item_set_autoselect_bool';
procedure obs_data_item_set_autoselect_obj(AItem: PPOBSDataItem; AValue: POBSData); cdecl; external 'obs.dll' name 'obs_data_item_set_autoselect_obj';
procedure obs_data_item_set_autoselect_array(AItem: PPOBSDataItem; AValue: POBSDataArray); cdecl; external 'obs.dll' name 'obs_data_item_set_autoselect_array';
function obs_data_item_get_default_string(AItem: POBSDataItem): PAnsiChar; cdecl; external 'obs.dll' name 'obs_data_item_get_default_string';
function obs_data_item_get_default_int(AItem: POBSDataItem): Int64; cdecl; external 'obs.dll' name 'obs_data_item_get_default_int';
function obs_data_item_get_default_double(AItem: POBSDataItem): Double; cdecl; external 'obs.dll' name 'obs_data_item_get_default_double';
function obs_data_item_get_default_bool(AItem: POBSDataItem): Boolean; cdecl; external 'obs.dll' name 'obs_data_item_get_default_bool';
function obs_data_item_get_default_obj(AItem: POBSDataItem): POBSData; cdecl; external 'obs.dll' name 'obs_data_item_get_default_obj';
function obs_data_item_get_default_array(AItem: POBSDataItem): POBSDataArray; cdecl; external 'obs.dll' name 'obs_data_item_get_default_array';
function obs_data_item_get_autoselect_string(AItem: POBSDataItem): PAnsiChar; cdecl; external 'obs.dll' name 'obs_data_item_get_autoselect_string';
function obs_data_item_get_autoselect_int(AItem: POBSDataItem): Int64; cdecl; external 'obs.dll' name 'obs_data_item_get_autoselect_int';
function obs_data_item_get_autoselect_double(AItem: POBSDataItem): Double; cdecl; external 'obs.dll' name 'obs_data_item_get_autoselect_double';
function obs_data_item_get_autoselect_bool(AItem: POBSDataItem): Boolean; cdecl; external 'obs.dll' name 'obs_data_item_get_autoselect_bool';
function obs_data_item_get_autoselect_obj(AItem: POBSDataItem): POBSData; cdecl; external 'obs.dll' name 'obs_data_item_get_autoselect_obj';
function obs_data_item_get_autoselect_array(AItem: POBSDataItem): POBSDataArray; cdecl; external 'obs.dll' name 'obs_data_item_get_autoselect_array';
procedure obs_data_set_vec2(AData: POBSData; AName: PAnsiChar; AValue: POBSVec2); cdecl; external 'obs.dll' name 'obs_data_set_vec2';
procedure obs_data_set_vec3(AData: POBSData; AName: PAnsiChar; AValue: POBSVec3); cdecl; external 'obs.dll' name 'obs_data_set_vec3';
procedure obs_data_set_vec4(AData: POBSData; AName: PAnsiChar; AValue: POBSVec4); cdecl; external 'obs.dll' name 'obs_data_set_vec4';
procedure obs_data_set_quat(AData: POBSData; AName: PAnsiChar; AValue: POBSQuat); cdecl; external 'obs.dll' name 'obs_data_set_quat';
procedure obs_data_set_default_vec2(AData: POBSData; AName: PAnsiChar; AValue: POBSVec2); cdecl; external 'obs.dll' name 'obs_data_set_default_vec2';
procedure obs_data_set_default_vec3(AData: POBSData; AName: PAnsiChar; AValue: POBSVec3); cdecl; external 'obs.dll' name 'obs_data_set_default_vec3';
procedure obs_data_set_default_vec4(AData: POBSData; AName: PAnsiChar; AValue: POBSVec4); cdecl; external 'obs.dll' name 'obs_data_set_default_vec4';
procedure obs_data_set_default_quat(AData: POBSData; AName: PAnsiChar; AValue: POBSQuat); cdecl; external 'obs.dll' name 'obs_data_set_default_quat';
procedure obs_data_set_autoselect_vec2(AData: POBSData; AName: PAnsiChar; AValue: POBSVec2); cdecl; external 'obs.dll' name 'obs_data_set_autoselect_vec2';
procedure obs_data_set_autoselect_vec3(AData: POBSData; AName: PAnsiChar; AValue: POBSVec3); cdecl; external 'obs.dll' name 'obs_data_set_autoselect_vec3';
procedure obs_data_set_autoselect_vec4(AData: POBSData; AName: PAnsiChar; AValue: POBSVec4); cdecl; external 'obs.dll' name 'obs_data_set_autoselect_vec4';
procedure obs_data_set_autoselect_quat(AData: POBSData; AName: PAnsiChar; AValue: POBSQuat); cdecl; external 'obs.dll' name 'obs_data_set_autoselect_quat';
procedure obs_data_get_vec2(AData: POBSData; AName: PAnsiChar; AValue: POBSVec2); cdecl; external 'obs.dll' name 'obs_data_get_vec2';
procedure obs_data_get_vec3(AData: POBSData; AName: PAnsiChar; AValue: POBSVec3); cdecl; external 'obs.dll' name 'obs_data_get_vec3';
procedure obs_data_get_vec4(AData: POBSData; AName: PAnsiChar; AValue: POBSVec4); cdecl; external 'obs.dll' name 'obs_data_get_vec4';
procedure obs_data_get_quat(AData: POBSData; AName: PAnsiChar; AValue: POBSQuat); cdecl; external 'obs.dll' name 'obs_data_get_quat';
procedure obs_data_get_default_vec2(AData: POBSData; AName: PAnsiChar; AValue: POBSVec2); cdecl; external 'obs.dll' name 'obs_data_get_default_vec2';
procedure obs_data_get_default_vec3(AData: POBSData; AName: PAnsiChar; AValue: POBSVec3); cdecl; external 'obs.dll' name 'obs_data_get_default_vec3';
procedure obs_data_get_default_vec4(AData: POBSData; AName: PAnsiChar; AValue: POBSVec4); cdecl; external 'obs.dll' name 'obs_data_get_default_vec4';
procedure obs_data_get_default_quat(AData: POBSData; AName: PAnsiChar; AValue: POBSQuat); cdecl; external 'obs.dll' name 'obs_data_get_default_quat';
procedure obs_data_get_autoselect_vec2(AData: POBSData; AName: PAnsiChar; AValue: POBSVec2); cdecl; external 'obs.dll' name 'obs_data_get_autoselect_vec2';
procedure obs_data_get_autoselect_vec3(AData: POBSData; AName: PAnsiChar; AValue: POBSVec3); cdecl; external 'obs.dll' name 'obs_data_get_autoselect_vec3';
procedure obs_data_get_autoselect_vec4(AData: POBSData; AName: PAnsiChar; AValue: POBSVec4); cdecl; external 'obs.dll' name 'obs_data_get_autoselect_vec4';
procedure obs_data_get_autoselect_quat(AData: POBSData; AName: PAnsiChar; AValue: POBSQuat); cdecl; external 'obs.dll' name 'obs_data_get_autoselect_quat';
procedure obs_data_set_frames_per_second(AData: POBSData; AName: PAnsiChar; AFps: TOBSMediaFramesPerSecond; AOption: PAnsiChar); cdecl; external 'obs.dll' name 'obs_data_set_frames_per_second';
procedure obs_data_set_default_frames_per_second(AData: POBSData; AName: PAnsiChar; AFps: TOBSMediaFramesPerSecond; AOption: PAnsiChar); cdecl; external 'obs.dll' name 'obs_data_set_default_frames_per_second';
procedure obs_data_set_autoselect_frames_per_second(AData: POBSData; AName: PAnsiChar; AFps: TOBSMediaFramesPerSecond; AOption: PAnsiChar); cdecl; external 'obs.dll' name 'obs_data_set_autoselect_frames_per_second';
function obs_data_get_frames_per_second(AData: POBSData; AName: PAnsiChar; AFps: POBSMediaFramesPerSecond; AOption: PPAnsiChar): Boolean; cdecl; external 'obs.dll' name 'obs_data_get_frames_per_second';
function obs_data_get_default_frames_per_second(AData: POBSData; AName: PAnsiChar; AFps: POBSMediaFramesPerSecond; AOption: PPAnsiChar): Boolean; cdecl; external 'obs.dll' name 'obs_data_get_default_frames_per_second';
function obs_data_get_autoselect_frames_per_second(AData: POBSData; AName: PAnsiChar; AFps: POBSMediaFramesPerSecond; AOption: PPAnsiChar): Boolean; cdecl; external 'obs.dll' name 'obs_data_get_autoselect_frames_per_second';
procedure obs_data_item_set_frames_per_second(AItem: PPOBSDataItem; AFps: TOBSMediaFramesPerSecond; AOption: PAnsiChar); cdecl; external 'obs.dll' name 'obs_data_item_set_frames_per_second';
procedure obs_data_item_set_default_frames_per_second(AItem: PPOBSDataItem; AFps: TOBSMediaFramesPerSecond; AOption: PAnsiChar); cdecl; external 'obs.dll' name 'obs_data_item_set_default_frames_per_second';
procedure obs_data_item_set_autoselect_frames_per_second(AItem: PPOBSDataItem; AFps: TOBSMediaFramesPerSecond; AOption: PAnsiChar); cdecl; external 'obs.dll' name 'obs_data_item_set_autoselect_frames_per_second';
function obs_data_item_get_frames_per_second(AItem: POBSDataItem; AFps: POBSMediaFramesPerSecond; AOption: PPAnsiChar): Boolean; cdecl; external 'obs.dll' name 'obs_data_item_get_frames_per_second';
function obs_data_item_get_default_frames_per_second(AItem: POBSDataItem; AFps: POBSMediaFramesPerSecond; AOption: PPAnsiChar): Boolean; cdecl; external 'obs.dll' name 'obs_data_item_get_default_frames_per_second';
function obs_data_item_get_autoselect_frames_per_second(AItem: POBSDataItem; AFps: POBSMediaFramesPerSecond; AOption: PPAnsiChar): Boolean; cdecl; external 'obs.dll' name 'obs_data_item_get_autoselect_frames_per_second';

implementation

end.
