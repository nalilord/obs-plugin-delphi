unit XENOME.OBS.Properties;

interface

uses
  XENOME.OBS.Types, XENOME.OBS.Data, XENOME.OBS.Misc;

type
  POBSProperty = ^TOBSProperty;
  PPOBSProperty = ^POBSProperty;
  POBSProperties = ^TOBSProperties;

  TOBSPropertyModified = function(Props: POBSProperties; Prop: POBSProperty; Settings: POBSData): Boolean cdecl;
  TOBSPropertyModified2 = function(Priv: Pointer; Props: POBSProperties; Prop: POBSProperty; Settings: POBSData): Boolean cdecl;
  TOBSPropertyClicked = function(Props: POBSProperties; Prop: POBSProperty; Data: Pointer): Boolean cdecl;
  TOBSPropertyDestroyProc = procedure(Data: Pointer) cdecl;

  TOBSProperty = record
    Name: PAnsiChar;
    Desc: PAnsiChar;
    LongDesc: PAnsiChar;
    Priv: Pointer;
    Typ: TOBSPropertyType;
    Visible: Boolean;
    Enabled: Boolean;
    Parent: POBSProperty;
    Modified: TOBSPropertyModified;
    Modified2: TOBSPropertyModified2;
    HashHandle: UT_hash_handle;
  end;

  TOBSProperties = record
	  Param: Pointer;
	  Destroy: TOBSPropertyDestroyProc;
	  Flags: Cardinal;
	  Groups: Cardinal;
    Properties: POBSProperty;
	  Parent: POBSProperty;
  end;

function obs_properties_create: POBSProperties; cdecl; external 'obs.dll' name 'obs_properties_create';
function obs_properties_create_param(AParam: Pointer; ADestroy: TOBSPropertyDestroyProc): POBSProperties; cdecl; external 'obs.dll' name 'obs_properties_create_param';
procedure obs_properties_destroy(AProps: POBSProperties); cdecl; external 'obs.dll' name 'obs_properties_destroy';
procedure obs_properties_set_flags(AProps: POBSProperties; AFlags: Cardinal); cdecl; external 'obs.dll' name 'obs_properties_set_flags';
function obs_properties_get_flags(AProps: POBSProperties): Cardinal; cdecl; external 'obs.dll' name 'obs_properties_get_flags';
procedure obs_properties_set_param(AProps: POBSProperties; AParam: Pointer; ADestroy: TOBSPropertyDestroyProc); cdecl; external 'obs.dll' name 'obs_properties_set_param';
function obs_properties_get_param(AProps: POBSProperties): Pointer; cdecl; external 'obs.dll' name 'obs_properties_get_param';
function obs_properties_first(AProps: POBSProperties): POBSProperty; cdecl; external 'obs.dll' name 'obs_properties_first';
function obs_properties_get(AProps: POBSProperties; AProperty: PAnsiChar): POBSProperty; cdecl; external 'obs.dll' name 'obs_properties_get';
function obs_properties_get_parent(AProps: POBSProperties): POBSProperties; cdecl; external 'obs.dll' name 'obs_properties_get_parent';
procedure obs_properties_remove_by_name(AProps: POBSProperties; AProperty: PAnsiChar); cdecl; external 'obs.dll' name 'obs_properties_remove_by_name';
procedure obs_properties_apply_settings(AProps: POBSProperties; ASettings: POBSData); cdecl; external 'obs.dll' name 'obs_properties_apply_settings';
function obs_properties_add_bool(AProps: POBSProperties; AName, ADescription: PAnsiChar): POBSProperty; cdecl; external 'obs.dll' name 'obs_properties_add_bool';
function obs_properties_add_int(AProps: POBSProperties; AName, ADescription: PAnsiChar; AMin, AMax, AStep: Integer): POBSProperty; cdecl; external 'obs.dll' name 'obs_properties_add_int';
function obs_properties_add_float(AProps: POBSProperties; AName, ADescription: PAnsiChar; AMin, AMax, AStep: Double): POBSProperty; cdecl; external 'obs.dll' name 'obs_properties_add_float';
function obs_properties_add_int_slider(AProps: POBSProperties; AName, ADescription: PAnsiChar; AMin, AMax, AStep: Integer): POBSProperty; cdecl; external 'obs.dll' name 'obs_properties_add_int_slider';
function obs_properties_add_float_slider(AProps: POBSProperties; AName, ADescription: PAnsiChar; AMin, AMax, AStep: Double): POBSProperty; cdecl; external 'obs.dll' name 'obs_properties_add_float_slider';
function obs_properties_add_text(AProps: POBSProperties; AName, ADescription: PAnsiChar; ATyp: TOBSTextType): POBSProperty; cdecl; external 'obs.dll' name 'obs_properties_add_text';
function obs_properties_add_path(AProps: POBSProperties; AName, ADescription: PAnsiChar; ATyp: TOBSPathType; AFilter, ADefaultPath: PAnsiChar): POBSProperty; cdecl; external 'obs.dll' name 'obs_properties_add_path';
function obs_properties_add_list(AProps: POBSProperties; AName, ADescription: PAnsiChar; ATyp: TOBSComboType; AFormat: TOBSComboFormat): POBSProperty; cdecl; external 'obs.dll' name 'obs_properties_add_list';
function obs_properties_add_color(AProps: POBSProperties; AName, ADescription: PAnsiChar): POBSProperty; cdecl; external 'obs.dll' name 'obs_properties_add_color';
function obs_properties_add_color_alpha(AProps: POBSProperties; AName, ADescription: PAnsiChar): POBSProperty; cdecl; external 'obs.dll' name 'obs_properties_add_color_alpha';
function obs_properties_add_button(AProps: POBSProperties; AName, AText: PAnsiChar; ACallback: TOBSPropertyClicked): POBSProperty; cdecl; external 'obs.dll' name 'obs_properties_add_button';
function obs_properties_add_button2(AProps: POBSProperties; AName, AText: PAnsiChar; ACallback: TOBSPropertyClicked; APriv: Pointer): POBSProperty; cdecl; external 'obs.dll' name 'obs_properties_add_button2';
function obs_properties_add_font(AProps: POBSProperties; AName, ADescription: PAnsiChar): POBSProperty; cdecl; external 'obs.dll' name 'obs_properties_add_font';
function obs_properties_add_editable_list(AProps: POBSProperties; AName, ADescription: PAnsiChar; ATyp: TOBSEditableListType; AFilter, ADefaultPath: PAnsiChar): POBSProperty; cdecl; external 'obs.dll' name 'obs_properties_add_editable_list';
function obs_properties_add_frame_rate(AProps: POBSProperties; AName, ADescription: PAnsiChar): POBSProperty; cdecl; external 'obs.dll' name 'obs_properties_add_frame_rate';
function obs_properties_add_group(AProps: POBSProperties; AName, ADescription: PAnsiChar; ATyp: TOBSGroupType; AGroup: POBSProperties): POBSProperty; cdecl; external 'obs.dll' name 'obs_properties_add_group';
procedure obs_property_set_modified_callback(AProp: POBSProperty; AModified: TOBSPropertyModified); cdecl; external 'obs.dll' name 'obs_property_set_modified_callback';
procedure obs_property_set_modified_callback2(AProp: POBSProperty; AModified: TOBSPropertyModified2; APriv: Pointer); cdecl; external 'obs.dll' name 'obs_property_set_modified_callback2';
function obs_property_modified(AProp: POBSProperty; ASettings: POBSData): Boolean; cdecl; external 'obs.dll' name 'obs_property_modified';
function obs_property_button_clicked(AProp: POBSProperty; AObject: Pointer): Boolean; cdecl; external 'obs.dll' name 'obs_property_button_clicked';
procedure obs_property_set_visible(AProp: POBSProperty; AVisible: Boolean); cdecl; external 'obs.dll' name 'obs_property_set_visible';
procedure obs_property_set_enabled(AProp: POBSProperty; AEnabled: Boolean); cdecl; external 'obs.dll' name 'obs_property_set_enabled';
procedure obs_property_set_description(AProp: POBSProperty; ADescription: PAnsiChar); cdecl; external 'obs.dll' name 'obs_property_set_description';
procedure obs_property_set_long_description(AProp: POBSProperty; ALongDescription: PAnsiChar); cdecl; external 'obs.dll' name 'obs_property_set_long_description';
function obs_property_name(AProp: POBSProperty): PAnsiChar; cdecl; external 'obs.dll' name 'obs_property_name';
function obs_property_description(AProp: POBSProperty): PAnsiChar; cdecl; external 'obs.dll' name 'obs_property_description';
function obs_property_long_description(AProp: POBSProperty): PAnsiChar; cdecl; external 'obs.dll' name 'obs_property_long_description';
function obs_property_get_type(AProp: POBSProperty): TOBSPropertyType; cdecl; external 'obs.dll' name 'obs_property_get_type';
function obs_property_enabled(AProp: POBSProperty): Boolean; cdecl; external 'obs.dll' name 'obs_property_enabled';
function obs_property_visible(AProp: POBSProperty): Boolean; cdecl; external 'obs.dll' name 'obs_property_visible';
function obs_property_next(AProp: PPOBSProperty): Boolean; cdecl; external 'obs.dll' name 'obs_property_next';
function obs_property_int_min(AProp: POBSProperty): Integer; cdecl; external 'obs.dll' name 'obs_property_int_min';
function obs_property_int_max(AProp: POBSProperty): Integer; cdecl; external 'obs.dll' name 'obs_property_int_max';
function obs_property_int_step(AProp: POBSProperty): Integer; cdecl; external 'obs.dll' name 'obs_property_int_step';
function obs_property_int_type(AProp: POBSProperty): TOBSNumberType; cdecl; external 'obs.dll' name 'obs_property_int_type';
function obs_property_int_suffix(AProp: POBSProperty): PAnsiChar; cdecl; external 'obs.dll' name 'obs_property_int_suffix';
function obs_property_float_min(AProp: POBSProperty): Double; cdecl; external 'obs.dll' name 'obs_property_float_min';
function obs_property_float_max(AProp: POBSProperty): Double; cdecl; external 'obs.dll' name 'obs_property_float_max';
function obs_property_float_step(AProp: POBSProperty): Double; cdecl; external 'obs.dll' name 'obs_property_float_step';
function obs_property_float_type(AProp: POBSProperty): TOBSNumberType; cdecl; external 'obs.dll' name 'obs_property_float_type';
function obs_property_float_suffix(AProp: POBSProperty): PAnsiChar; cdecl; external 'obs.dll' name 'obs_property_float_suffix';
function obs_property_text_type(AProp: POBSProperty): TOBSTextType; cdecl; external 'obs.dll' name 'obs_property_text_type';
function obs_property_text_monospace(AProp: POBSProperty): Boolean; cdecl; external 'obs.dll' name 'obs_property_text_monospace';
function obs_property_text_info_type(AProp: POBSProperty): TOBSTextInfoType; cdecl; external 'obs.dll' name 'obs_property_text_info_type';
function obs_property_text_info_word_wrap(AProp: POBSProperty): Boolean; cdecl; external 'obs.dll' name 'obs_property_text_info_word_wrap';
function obs_property_path_type(AProp: POBSProperty): TOBSPathType; cdecl; external 'obs.dll' name 'obs_property_path_type';
function obs_property_path_filter(AProp: POBSProperty): PAnsiChar; cdecl; external 'obs.dll' name 'obs_property_path_filter';
function obs_property_path_default_path(AProp: POBSProperty): PAnsiChar; cdecl; external 'obs.dll' name 'obs_property_path_default_path';
function obs_property_list_type(AProp: POBSProperty): TOBSComboType; cdecl; external 'obs.dll' name 'obs_property_list_type';
function obs_property_list_format(AProp: POBSProperty): TOBSComboFormat; cdecl; external 'obs.dll' name 'obs_property_list_format';
procedure obs_property_int_set_limits(AProp: POBSProperty; AMin, AMax, AStep: Integer); cdecl; external 'obs.dll' name 'obs_property_int_set_limits';
procedure obs_property_float_set_limits(AProp: POBSProperty; AMin, AMax, AStep: Double); cdecl; external 'obs.dll' name 'obs_property_float_set_limits';
procedure obs_property_int_set_suffix(AProp: POBSProperty; ASuffix: PAnsiChar); cdecl; external 'obs.dll' name 'obs_property_int_set_suffix';
procedure obs_property_float_set_suffix(AProp: POBSProperty; ASuffix: PAnsiChar); cdecl; external 'obs.dll' name 'obs_property_float_set_suffix';
procedure obs_property_text_set_monospace(AProp: POBSProperty; AMonospace: Boolean); cdecl; external 'obs.dll' name 'obs_property_text_set_monospace';
procedure obs_property_text_set_info_type(AProp: POBSProperty; ATyp: TOBSTextInfoType); cdecl; external 'obs.dll' name 'obs_property_text_set_info_type';
procedure obs_property_text_set_info_word_wrap(AProp: POBSProperty; AWordWrap: Boolean); cdecl; external 'obs.dll' name 'obs_property_text_set_info_word_wrap';
procedure obs_property_button_set_type(AProp: POBSProperty; ATyp: TOBSButtonType); cdecl; external 'obs.dll' name 'obs_property_button_set_type';
procedure obs_property_button_set_url(AProp: POBSProperty; AUrl: PAnsiChar); cdecl; external 'obs.dll' name 'obs_property_button_set_url';
procedure obs_property_list_clear(AProp: POBSProperty); cdecl; external 'obs.dll' name 'obs_property_list_clear';
function obs_property_list_add_string(AProp: POBSProperty; AName, AValue: PAnsiChar): NativeUInt; cdecl; external 'obs.dll' name 'obs_property_list_add_string';
function obs_property_list_add_int(AProp: POBSProperty; AName: PAnsiChar; AValue: Int64): NativeUInt; cdecl; external 'obs.dll' name 'obs_property_list_add_int';
function obs_property_list_add_float(AProp: POBSProperty; AName: PAnsiChar; AValue: Double): NativeUInt; cdecl; external 'obs.dll' name 'obs_property_list_add_float';
function obs_property_list_add_bool(AProp: POBSProperty; AName: PAnsiChar; AValue: Boolean): NativeUInt; cdecl; external 'obs.dll' name 'obs_property_list_add_bool';
procedure obs_property_list_insert_string(AProp: POBSProperty; AIndex: NativeUInt; AName, AValue: PAnsiChar); cdecl; external 'obs.dll' name 'obs_property_list_insert_string';
procedure obs_property_list_insert_int(AProp: POBSProperty; AIndex: NativeUInt; AName: PAnsiChar; AValue: Int64); cdecl; external 'obs.dll' name 'obs_property_list_insert_int';
procedure obs_property_list_insert_float(AProp: POBSProperty; AIndex: NativeUInt; AName: PAnsiChar; AValue: Double); cdecl; external 'obs.dll' name 'obs_property_list_insert_float';
procedure obs_property_list_insert_bool(AProp: POBSProperty; AIndex: NativeUInt; AName: PAnsiChar; AValue: Boolean); cdecl; external 'obs.dll' name 'obs_property_list_insert_bool';
procedure obs_property_list_item_disable(AProp: POBSProperty; AIndex: NativeUInt; ADisabled: Boolean); cdecl; external 'obs.dll' name 'obs_property_list_item_disable';
function obs_property_list_item_disabled(AProp: POBSProperty; AIndex: NativeUInt): Boolean; cdecl; external 'obs.dll' name 'obs_property_list_item_disabled';
procedure obs_property_list_item_remove(AProp: POBSProperty; AIndex: NativeUInt); cdecl; external 'obs.dll' name 'obs_property_list_item_remove';
function obs_property_list_item_count(AProp: POBSProperty): NativeUInt; cdecl; external 'obs.dll' name 'obs_property_list_item_count';
function obs_property_list_item_name(AProp: POBSProperty; AIndex: NativeUInt): PAnsiChar; cdecl; external 'obs.dll' name 'obs_property_list_item_name';
function obs_property_list_item_string(AProp: POBSProperty; AIndex: NativeUInt): PAnsiChar; cdecl; external 'obs.dll' name 'obs_property_list_item_string';
function obs_property_list_item_int(AProp: POBSProperty; AIndex: NativeUInt): Int64; cdecl; external 'obs.dll' name 'obs_property_list_item_int';
function obs_property_list_item_float(AProp: POBSProperty; AIndex: NativeUInt): Double; cdecl; external 'obs.dll' name 'obs_property_list_item_float';
function obs_property_list_item_bool(AProp: POBSProperty; AIndex: NativeUInt): Boolean; cdecl; external 'obs.dll' name 'obs_property_list_item_bool';
function obs_property_editable_list_type(AProp: POBSProperty): TOBSEditableListType; cdecl; external 'obs.dll' name 'obs_property_editable_list_type';
function obs_property_editable_list_filter(AProp: POBSProperty): PAnsiChar; cdecl; external 'obs.dll' name 'obs_property_editable_list_filter';
function obs_property_editable_list_default_path(AProp: POBSProperty): PAnsiChar; cdecl; external 'obs.dll' name 'obs_property_editable_list_default_path';
procedure obs_property_frame_rate_clear(AProp: POBSProperty); cdecl; external 'obs.dll' name 'obs_property_frame_rate_clear';
procedure obs_property_frame_rate_options_clear(AProp: POBSProperty); cdecl; external 'obs.dll' name 'obs_property_frame_rate_options_clear';
procedure obs_property_frame_rate_fps_ranges_clear(AProp: POBSProperty); cdecl; external 'obs.dll' name 'obs_property_frame_rate_fps_ranges_clear';
function obs_property_frame_rate_option_add(AProp: POBSProperty; AName, ADescription: PAnsiChar): NativeUInt; cdecl; external 'obs.dll' name 'obs_property_frame_rate_option_add';
function obs_property_frame_rate_fps_range_add(AProp: POBSProperty; AMin, AMax: TOBSMediaFramesPerSecond): NativeUInt; cdecl; external 'obs.dll' name 'obs_property_frame_rate_fps_range_add';
procedure obs_property_frame_rate_option_insert(AProp: POBSProperty; AIndex: NativeUInt; AName, ADescription: PAnsiChar); cdecl; external 'obs.dll' name 'obs_property_frame_rate_option_insert';
procedure obs_property_frame_rate_fps_range_insert(AProp: POBSProperty; AIndex: NativeUInt; AMin, AMax: TOBSMediaFramesPerSecond); cdecl; external 'obs.dll' name 'obs_property_frame_rate_fps_range_insert';
function obs_property_frame_rate_options_count(AProp: POBSProperty): NativeUInt; cdecl; external 'obs.dll' name 'obs_property_frame_rate_options_count';
function obs_property_frame_rate_option_name(AProp: POBSProperty; AIndex: NativeUInt): PAnsiChar; cdecl; external 'obs.dll' name 'obs_property_frame_rate_option_name';
function obs_property_frame_rate_option_description(AProp: POBSProperty; AIndex: NativeUInt): PAnsiChar; cdecl; external 'obs.dll' name 'obs_property_frame_rate_option_description';
function obs_property_frame_rate_fps_ranges_count(AProp: POBSProperty): NativeUInt; cdecl; external 'obs.dll' name 'obs_property_frame_rate_fps_ranges_count';
function obs_property_frame_rate_fps_range_min(AProp: POBSProperty; AIndex: NativeUInt): TOBSMediaFramesPerSecond; cdecl; external 'obs.dll' name 'obs_property_frame_rate_fps_range_min';
function obs_property_frame_rate_fps_range_max(AProp: POBSProperty; AIndex: NativeUInt): TOBSMediaFramesPerSecond; cdecl; external 'obs.dll' name 'obs_property_frame_rate_fps_range_max';
function obs_property_group_type(AProp: POBSProperty): TOBSGroupType; cdecl; external 'obs.dll' name 'obs_property_group_type';
function obs_property_group_content(AProp: POBSProperty): POBSProperties; cdecl; external 'obs.dll' name 'obs_property_group_content';
function obs_property_button_type(AProp: POBSProperty): TOBSButtonType; cdecl; external 'obs.dll' name 'obs_property_button_type';
function obs_property_button_url(AProp: POBSProperty): PAnsiChar; cdecl; external 'obs.dll' name 'obs_property_button_url';

implementation

end.
