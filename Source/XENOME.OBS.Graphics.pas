unit XENOME.OBS.Graphics;

interface

uses
  XENOME.OBS.Types, XENOME.OBS.Math;

type
  POBSGraphics = ^TOBSGraphics;
  TOBSGraphics = record end;

  POBSGSEffect = ^TOBSGSEffect;
  TOBSGSEffect = record end;

  POBSGSEffectParam = ^TOBSGSEffectParam;
  TOBSGSEffectParam = record end;

  POBSGSTechnique = ^TOBSGSTechnique;
  TOBSGSTechnique = record end;

  POBSGSEffectPass = ^TOBSGSEffectPass;
  TOBSGSEffectPass = record end;

  POBSGSTexRender = ^TOBSGSTexRender;
  TOBSGSTexRender = record end;

  POBSGSShader = ^TOBSGSShader;
  TOBSGSShader = record end;

  POBSGSShaderParam = ^TOBSGSShaderParam;
  TOBSGSShaderParam = record end;

  POBSGSSamplerState = ^TOBSGSSamplerState;
  TOBSGSSamplerState = record end;

  POBSGSStageSurface = ^TOBSGSStageSurface;
  TOBSGSStageSurface = record end;

  POBSGSIndexBuffer = ^TOBSGSIndexBuffer;
  TOBSGSIndexBuffer = record end;

  POBSGSSwapChain = ^TOBSGSSwapChain;
  TOBSGSSwapChain = record end;

  POBSGSTimer = ^TOBSGSTimer;
  TOBSGSTimer = record end;

  POBSGSTimerRange = ^TOBSGSTimerRange;
  TOBSGSTimerRange = record end;

  TOBSGSAdapterEnumCallback = function(Param: Pointer; Name: PAnsiChar; Id: Cardinal): Boolean cdecl;

function obs_get_base_effect(AEffect: TOBSBaseEffect): POBSGSEffect; cdecl; external 'obs.dll' name 'obs_get_base_effect';
function obs_get_main_texture: POBSGSTexture; cdecl; external 'obs.dll' name 'obs_get_main_texture';
function gs_get_device_name: PAnsiChar; cdecl; external 'obs.dll' name 'gs_get_device_name';
function gs_get_driver_version: PAnsiChar; cdecl; external 'obs.dll' name 'gs_get_driver_version';
function gs_get_renderer: PAnsiChar; cdecl; external 'obs.dll' name 'gs_get_renderer';
function gs_get_gpu_dmem: UInt64; cdecl; external 'obs.dll' name 'gs_get_gpu_dmem';
function gs_get_gpu_smem: UInt64; cdecl; external 'obs.dll' name 'gs_get_gpu_smem';
function gs_get_device_type: Integer; cdecl; external 'obs.dll' name 'gs_get_device_type';
function gs_get_adapter_count: Cardinal; cdecl; external 'obs.dll' name 'gs_get_adapter_count';
procedure gs_enum_adapters(ACallback: TOBSGSAdapterEnumCallback; AParam: Pointer); cdecl; external 'obs.dll' name 'gs_enum_adapters';
procedure gs_enter_context(AGraphics: POBSGraphics); cdecl; external 'obs.dll' name 'gs_enter_context';
procedure gs_leave_context; cdecl; external 'obs.dll' name 'gs_leave_context';
function gs_get_context: POBSGraphics; cdecl; external 'obs.dll' name 'gs_get_context';
function gs_get_device_obj: Pointer; cdecl; external 'obs.dll' name 'gs_get_device_obj';
function gs_get_effect: POBSGSEffect; cdecl; external 'obs.dll' name 'gs_get_effect';
function gs_effect_create_from_file(AFile: PAnsiChar; AErrorString: PPAnsiChar): POBSGSEffect; cdecl; external 'obs.dll' name 'gs_effect_create_from_file';
function gs_effect_create(AEffectString, AFilename: PAnsiChar; AErrorString: PPAnsiChar): POBSGSEffect; cdecl; external 'obs.dll' name 'gs_effect_create';
procedure gs_effect_destroy(AEffect: POBSGSEffect); cdecl; external 'obs.dll' name 'gs_effect_destroy';
function gs_effect_get_technique(AEffect: POBSGSEffect; AName: PAnsiChar): POBSGSTechnique; cdecl; external 'obs.dll' name 'gs_effect_get_technique';
function gs_effect_get_current_technique(AEffect: POBSGSEffect): POBSGSTechnique; cdecl; external 'obs.dll' name 'gs_effect_get_current_technique';
function gs_technique_begin(ATechnique: POBSGSTechnique): NativeUInt; cdecl; external 'obs.dll' name 'gs_technique_begin';
procedure gs_technique_end(ATechnique: POBSGSTechnique); cdecl; external 'obs.dll' name 'gs_technique_end';
function gs_technique_begin_pass(ATechnique: POBSGSTechnique; APass: NativeUInt): Boolean; cdecl; external 'obs.dll' name 'gs_technique_begin_pass';
function gs_technique_begin_pass_by_name(ATechnique: POBSGSTechnique; AName: PAnsiChar): Boolean; cdecl; external 'obs.dll' name 'gs_technique_begin_pass_by_name';
procedure gs_technique_end_pass(ATechnique: POBSGSTechnique); cdecl; external 'obs.dll' name 'gs_technique_end_pass';
function gs_technique_get_pass_by_idx(ATechnique: POBSGSTechnique; APass: NativeUInt): POBSGSEffectPass; cdecl; external 'obs.dll' name 'gs_technique_get_pass_by_idx';
function gs_technique_get_pass_by_name(ATechnique: POBSGSTechnique; AName: PAnsiChar): POBSGSEffectPass; cdecl; external 'obs.dll' name 'gs_technique_get_pass_by_name';
function gs_effect_get_num_params(AEffect: POBSGSEffect): NativeUInt; cdecl; external 'obs.dll' name 'gs_effect_get_num_params';
function gs_effect_get_param_by_idx(AEffect: POBSGSEffect; AParam: NativeUInt): POBSGSEffectParam; cdecl; external 'obs.dll' name 'gs_effect_get_param_by_idx';
function gs_effect_get_param_by_name(AEffect: POBSGSEffect; AName: PAnsiChar): POBSGSEffectParam; cdecl; external 'obs.dll' name 'gs_effect_get_param_by_name';
function gs_effect_get_viewproj_matrix(AEffect: POBSGSEffect): POBSGSEffectParam; cdecl; external 'obs.dll' name 'gs_effect_get_viewproj_matrix';
function gs_effect_get_world_matrix(AEffect: POBSGSEffect): POBSGSEffectParam; cdecl; external 'obs.dll' name 'gs_effect_get_world_matrix';
function gs_effect_loop(AEffect: POBSGSEffect; AName: PAnsiChar): Boolean; cdecl; external 'obs.dll' name 'gs_effect_loop';
procedure gs_effect_update_params(AEffect: POBSGSEffect); cdecl; external 'obs.dll' name 'gs_effect_update_params';
procedure gs_effect_set_bool(AParam: POBSGSEffectParam; AValue: Boolean); cdecl; external 'obs.dll' name 'gs_effect_set_bool';
procedure gs_effect_set_float(AParam: POBSGSEffectParam; AValue: Single); cdecl; external 'obs.dll' name 'gs_effect_set_float';
procedure gs_effect_set_int(AParam: POBSGSEffectParam; AValue: Integer); cdecl; external 'obs.dll' name 'gs_effect_set_int';
procedure gs_effect_set_matrix4(AParam: POBSGSEffectParam; AValue: POBSMatrix4); cdecl; external 'obs.dll' name 'gs_effect_set_matrix4';
procedure gs_effect_set_vec2(AParam: POBSGSEffectParam; AValue: POBSVec2); cdecl; external 'obs.dll' name 'gs_effect_set_vec2';
procedure gs_effect_set_vec3(AParam: POBSGSEffectParam; AValue: POBSVec3); cdecl; external 'obs.dll' name 'gs_effect_set_vec3';
procedure gs_effect_set_vec4(AParam: POBSGSEffectParam; AValue: POBSVec4); cdecl; external 'obs.dll' name 'gs_effect_set_vec4';
procedure gs_effect_set_texture(AParam: POBSGSEffectParam; AValue: POBSGSTexture); cdecl; external 'obs.dll' name 'gs_effect_set_texture';
procedure gs_effect_set_texture_srgb(AParam: POBSGSEffectParam; AValue: POBSGSTexture); cdecl; external 'obs.dll' name 'gs_effect_set_texture_srgb';
procedure gs_effect_set_val(AParam: POBSGSEffectParam; AValue: Pointer; ASize: NativeUInt); cdecl; external 'obs.dll' name 'gs_effect_set_val';
procedure gs_effect_set_default(AParam: POBSGSEffectParam); cdecl; external 'obs.dll' name 'gs_effect_set_default';
procedure gs_effect_set_color(AParam: POBSGSEffectParam; AARGB: Cardinal); cdecl; external 'obs.dll' name 'gs_effect_set_color';
function gs_effect_get_val_size(AParam: POBSGSEffectParam): NativeUInt; cdecl; external 'obs.dll' name 'gs_effect_get_val_size';
function gs_effect_get_val(AParam: POBSGSEffectParam): Pointer; cdecl; external 'obs.dll' name 'gs_effect_get_val';
function gs_effect_get_default_val_size(AParam: POBSGSEffectParam): NativeUInt; cdecl; external 'obs.dll' name 'gs_effect_get_default_val_size';
function gs_effect_get_default_val(AParam: POBSGSEffectParam): Pointer; cdecl; external 'obs.dll' name 'gs_effect_get_default_val';

procedure gs_shader_destroy(AShader: POBSGSShader); cdecl; external 'obs.dll' name 'gs_shader_destroy';
function gs_shader_get_num_params(AShader: POBSGSShader): Integer; cdecl; external 'obs.dll' name 'gs_shader_get_num_params';
function gs_shader_get_param_by_idx(AShader: POBSGSShader; AParam: Cardinal): POBSGSShaderParam; cdecl; external 'obs.dll' name 'gs_shader_get_param_by_idx';
function gs_shader_get_param_by_name(AShader: POBSGSShader; AName: PAnsiChar): POBSGSShaderParam; cdecl; external 'obs.dll' name 'gs_shader_get_param_by_name';
function gs_shader_get_viewproj_matrix(AShader: POBSGSShader): POBSGSShaderParam; cdecl; external 'obs.dll' name 'gs_shader_get_viewproj_matrix';
function gs_shader_get_world_matrix(AShader: POBSGSShader): POBSGSShaderParam; cdecl; external 'obs.dll' name 'gs_shader_get_world_matrix';
procedure gs_shader_get_param_info(AParam: POBSGSShaderParam; AInfo: POBSGSShaderParamInfo); cdecl; external 'obs.dll' name 'gs_shader_get_param_info';
procedure gs_shader_set_bool(AParam: POBSGSShaderParam; AValue: Boolean); cdecl; external 'obs.dll' name 'gs_shader_set_bool';
procedure gs_shader_set_float(AParam: POBSGSShaderParam; AValue: Single); cdecl; external 'obs.dll' name 'gs_shader_set_float';
procedure gs_shader_set_int(AParam: POBSGSShaderParam; AValue: Integer); cdecl; external 'obs.dll' name 'gs_shader_set_int';
procedure gs_shader_set_matrix3(AParam: POBSGSShaderParam; AValue: POBSMatrix3); cdecl; external 'obs.dll' name 'gs_shader_set_matrix3';
procedure gs_shader_set_matrix4(AParam: POBSGSShaderParam; AValue: POBSMatrix4); cdecl; external 'obs.dll' name 'gs_shader_set_matrix4';
procedure gs_shader_set_vec2(AParam: POBSGSShaderParam; AValue: POBSVec2); cdecl; external 'obs.dll' name 'gs_shader_set_vec2';
procedure gs_shader_set_vec3(AParam: POBSGSShaderParam; AValue: POBSVec3); cdecl; external 'obs.dll' name 'gs_shader_set_vec3';
procedure gs_shader_set_vec4(AParam: POBSGSShaderParam; AValue: POBSVec4); cdecl; external 'obs.dll' name 'gs_shader_set_vec4';
procedure gs_shader_set_texture(AParam: POBSGSShaderParam; AValue: POBSGSTexture); cdecl; external 'obs.dll' name 'gs_shader_set_texture';
procedure gs_shader_set_val(AParam: POBSGSShaderParam; AValue: Pointer; ASize: NativeUInt); cdecl; external 'obs.dll' name 'gs_shader_set_val';
procedure gs_shader_set_default(AParam: POBSGSShaderParam); cdecl; external 'obs.dll' name 'gs_shader_set_default';
procedure gs_shader_set_next_sampler(AParam: POBSGSShaderParam; ASampler: POBSGSSamplerState); cdecl; external 'obs.dll' name 'gs_shader_set_next_sampler';

function gs_vertexshader_create_from_file(AFile: PAnsiChar; AErrorString: PPAnsiChar): POBSGSShader; cdecl; external 'obs.dll' name 'gs_vertexshader_create_from_file';
function gs_pixelshader_create_from_file(AFile: PAnsiChar; AErrorString: PPAnsiChar): POBSGSShader; cdecl; external 'obs.dll' name 'gs_pixelshader_create_from_file';
function gs_vertexshader_create(AShader, AFile: PAnsiChar; AErrorString: PPAnsiChar): POBSGSShader; cdecl; external 'obs.dll' name 'gs_vertexshader_create';
function gs_pixelshader_create(AShader, AFile: PAnsiChar; AErrorString: PPAnsiChar): POBSGSShader; cdecl; external 'obs.dll' name 'gs_pixelshader_create';

function gs_texture_create_from_file(AFile: PAnsiChar): POBSGSTexture; cdecl; external 'obs.dll' name 'gs_texture_create_from_file';
function gs_create_texture_file_data(AFile: PAnsiChar; AFormat: POBSGSColorFormat; ACX, ACY: PCardinal): PByte; cdecl; external 'obs.dll' name 'gs_create_texture_file_data';
function gs_create_texture_file_data2(AFile: PAnsiChar; AAlphaMode: TOBSGSImageAlphaMode; AFormat: POBSGSColorFormat; ACX, ACY: PCardinal): PByte; cdecl; external 'obs.dll' name 'gs_create_texture_file_data2';
function gs_create_texture_file_data3(AFile: PAnsiChar; AAlphaMode: TOBSGSImageAlphaMode; AFormat: POBSGSColorFormat; ACX, ACY: PCardinal; ASpace: POBSGSColorSpace): PByte; cdecl; external 'obs.dll' name 'gs_create_texture_file_data3';
function gs_texrender_create(AFormat: TOBSGSColorFormat; AZStencilFormat: TOBSGSZStencilFormat): POBSGSTexRender; cdecl; external 'obs.dll' name 'gs_texrender_create';
procedure gs_texrender_destroy(ATexRender: POBSGSTexRender); cdecl; external 'obs.dll' name 'gs_texrender_destroy';
function gs_texrender_begin(ATexRender: POBSGSTexRender; ACX, ACY: Cardinal): Boolean; cdecl; external 'obs.dll' name 'gs_texrender_begin';
function gs_texrender_begin_with_color_space(ATexRender: POBSGSTexRender; ACX, ACY: Cardinal; ASpace: TOBSGSColorSpace): Boolean; cdecl; external 'obs.dll' name 'gs_texrender_begin_with_color_space';
procedure gs_texrender_end(ATexRender: POBSGSTexRender); cdecl; external 'obs.dll' name 'gs_texrender_end';
procedure gs_texrender_reset(ATexRender: POBSGSTexRender); cdecl; external 'obs.dll' name 'gs_texrender_reset';
function gs_texrender_get_texture(ATexRender: POBSGSTexRender): POBSGSTexture; cdecl; external 'obs.dll' name 'gs_texrender_get_texture';
function gs_texrender_get_format(ATexRender: POBSGSTexRender): TOBSGSColorFormat; cdecl; external 'obs.dll' name 'gs_texrender_get_format';

procedure gs_matrix_push; cdecl; external 'obs.dll' name 'gs_matrix_push';
procedure gs_matrix_pop; cdecl; external 'obs.dll' name 'gs_matrix_pop';
procedure gs_matrix_identity; cdecl; external 'obs.dll' name 'gs_matrix_identity';
procedure gs_matrix_transpose; cdecl; external 'obs.dll' name 'gs_matrix_transpose';
procedure gs_matrix_set(AMatrix: POBSMatrix4); cdecl; external 'obs.dll' name 'gs_matrix_set';
procedure gs_matrix_get(ADst: POBSMatrix4); cdecl; external 'obs.dll' name 'gs_matrix_get';
procedure gs_matrix_mul(AMatrix: POBSMatrix4); cdecl; external 'obs.dll' name 'gs_matrix_mul';
procedure gs_matrix_rotquat(ARotation: POBSQuat); cdecl; external 'obs.dll' name 'gs_matrix_rotquat';
procedure gs_matrix_rotaa(ARotation: POBSAxisAng); cdecl; external 'obs.dll' name 'gs_matrix_rotaa';
procedure gs_matrix_translate(APos: POBSVec3); cdecl; external 'obs.dll' name 'gs_matrix_translate';
procedure gs_matrix_scale(AScale: POBSVec3); cdecl; external 'obs.dll' name 'gs_matrix_scale';
procedure gs_matrix_rotaa4f(AX, AY, AZ, AAngle: Single); cdecl; external 'obs.dll' name 'gs_matrix_rotaa4f';
procedure gs_matrix_translate3f(AX, AY, AZ: Single); cdecl; external 'obs.dll' name 'gs_matrix_translate3f';
procedure gs_matrix_scale3f(AX, AY, AZ: Single); cdecl; external 'obs.dll' name 'gs_matrix_scale3f';

procedure gs_render_start(ANew: Boolean); cdecl; external 'obs.dll' name 'gs_render_start';
procedure gs_render_stop(AMode: TOBSGSDrawMode); cdecl; external 'obs.dll' name 'gs_render_stop';
function gs_render_save: POBSGSVertBuffer; cdecl; external 'obs.dll' name 'gs_render_save';
procedure gs_vertex2f(AX, AY: Single); cdecl; external 'obs.dll' name 'gs_vertex2f';
procedure gs_vertex3f(AX, AY, AZ: Single); cdecl; external 'obs.dll' name 'gs_vertex3f';
procedure gs_normal3f(AX, AY, AZ: Single); cdecl; external 'obs.dll' name 'gs_normal3f';
procedure gs_color(AColor: Cardinal); cdecl; external 'obs.dll' name 'gs_color';
procedure gs_texcoord(AX, AY: Single; AUnit: Integer); cdecl; external 'obs.dll' name 'gs_texcoord';
procedure gs_vertex2v(AVec: POBSVec2); cdecl; external 'obs.dll' name 'gs_vertex2v';
procedure gs_vertex3v(AVec: POBSVec3); cdecl; external 'obs.dll' name 'gs_vertex3v';
procedure gs_normal3v(AVec: POBSVec3); cdecl; external 'obs.dll' name 'gs_normal3v';
procedure gs_color4v(AVec: POBSVec4); cdecl; external 'obs.dll' name 'gs_color4v';
procedure gs_texcoord2v(AVec: POBSVec2; AUnit: Integer); cdecl; external 'obs.dll' name 'gs_texcoord2v';
procedure gs_draw_sprite(ATexture: POBSGSTexture; AFlip, AWidth, AHeight: Cardinal); cdecl; external 'obs.dll' name 'gs_draw_sprite';
procedure gs_draw_quadf(ATexture: POBSGSTexture; AFlip: Cardinal; AWidth, AHeight: Single); cdecl; external 'obs.dll' name 'gs_draw_quadf';
procedure gs_draw_sprite_subregion(ATexture: POBSGSTexture; AFlip, AX, AY, ACX, ACY: Cardinal); cdecl; external 'obs.dll' name 'gs_draw_sprite_subregion';
procedure gs_draw_cube_backdrop(ACubeTexture: POBSGSTexture; ARotation: POBSQuat; ALeft, ARight, ATop, ABottom, AZNear: Single); cdecl; external 'obs.dll' name 'gs_draw_cube_backdrop';
procedure gs_reset_viewport; cdecl; external 'obs.dll' name 'gs_reset_viewport';
procedure gs_set_2d_mode; cdecl; external 'obs.dll' name 'gs_set_2d_mode';
procedure gs_set_3d_mode(AFovy, AZNear, AZFar: Double); cdecl; external 'obs.dll' name 'gs_set_3d_mode';
procedure gs_viewport_push; cdecl; external 'obs.dll' name 'gs_viewport_push';
procedure gs_viewport_pop; cdecl; external 'obs.dll' name 'gs_viewport_pop';
procedure gs_texture_set_image(ATexture: POBSGSTexture; AData: PByte; ALineSize: Cardinal; AInvert: Boolean); cdecl; external 'obs.dll' name 'gs_texture_set_image';
procedure gs_cubetexture_set_image(ACubeTexture: POBSGSTexture; ASide: Cardinal; AData: Pointer; ALineSize: Cardinal; AInvert: Boolean); cdecl; external 'obs.dll' name 'gs_cubetexture_set_image';
procedure gs_perspective(AFovy, AAspect, AZNear, AZFar: Single); cdecl; external 'obs.dll' name 'gs_perspective';
procedure gs_blend_state_push; cdecl; external 'obs.dll' name 'gs_blend_state_push';
procedure gs_blend_state_pop; cdecl; external 'obs.dll' name 'gs_blend_state_pop';
procedure gs_reset_blend_state; cdecl; external 'obs.dll' name 'gs_reset_blend_state';
procedure gs_update_color_space; cdecl; external 'obs.dll' name 'gs_update_color_space';
procedure gs_resize(AX, AY: Cardinal); cdecl; external 'obs.dll' name 'gs_resize';
procedure gs_get_size(AX, AY: PCardinal); cdecl; external 'obs.dll' name 'gs_get_size';
function gs_get_width: Cardinal; cdecl; external 'obs.dll' name 'gs_get_width';
function gs_get_height: Cardinal; cdecl; external 'obs.dll' name 'gs_get_height';
function gs_texture_create(AWidth, AHeight: Cardinal; AColorFormat: TOBSGSColorFormat; ALevels: Cardinal; AData: PPByte; AFlags: Cardinal): POBSGSTexture; cdecl; external 'obs.dll' name 'gs_texture_create';
function gs_cubetexture_create(ASize: Cardinal; AColorFormat: TOBSGSColorFormat; ALevels: Cardinal; AData: PPByte; AFlags: Cardinal): POBSGSTexture; cdecl; external 'obs.dll' name 'gs_cubetexture_create';
function gs_voltexture_create(AWidth, AHeight, ADepth: Cardinal; AColorFormat: TOBSGSColorFormat; ALevels: Cardinal; AData: PPByte; AFlags: Cardinal): POBSGSTexture; cdecl; external 'obs.dll' name 'gs_voltexture_create';
function gs_zstencil_create(AWidth, AHeight: Cardinal; AFormat: TOBSGSZStencilFormat): POBSGSZStencil; cdecl; external 'obs.dll' name 'gs_zstencil_create';
function gs_stagesurface_create(AWidth, AHeight: Cardinal; AColorFormat: TOBSGSColorFormat): POBSGSStageSurface; cdecl; external 'obs.dll' name 'gs_stagesurface_create';
function gs_samplerstate_create(AInfo: POBSGSSamplerInfo): POBSGSSamplerState; cdecl; external 'obs.dll' name 'gs_samplerstate_create';
function gs_vertexbuffer_create(AData: POBSGSVBData; AFlags: Cardinal): POBSGSVertBuffer; cdecl; external 'obs.dll' name 'gs_vertexbuffer_create';
function gs_indexbuffer_create(AType: TOBSGSIndexType; AIndices: Pointer; ANum: NativeUInt; AFlags: Cardinal): POBSGSIndexBuffer; cdecl; external 'obs.dll' name 'gs_indexbuffer_create';
function gs_timer_create: POBSGSTimer; cdecl; external 'obs.dll' name 'gs_timer_create';
function gs_timer_range_create: POBSGSTimerRange; cdecl; external 'obs.dll' name 'gs_timer_range_create';
procedure gs_load_vertexbuffer(AVertBuffer: POBSGSVertBuffer); cdecl; external 'obs.dll' name 'gs_load_vertexbuffer';
procedure gs_load_indexbuffer(AIndexBuffer: POBSGSIndexBuffer); cdecl; external 'obs.dll' name 'gs_load_indexbuffer';
procedure gs_load_texture(ATexture: POBSGSTexture; AUnit: Integer); cdecl; external 'obs.dll' name 'gs_load_texture';
procedure gs_load_samplerstate(ASamplerState: POBSGSSamplerState; AUnit: Integer); cdecl; external 'obs.dll' name 'gs_load_samplerstate';
procedure gs_load_vertexshader(AShader: POBSGSShader); cdecl; external 'obs.dll' name 'gs_load_vertexshader';
procedure gs_load_pixelshader(AShader: POBSGSShader); cdecl; external 'obs.dll' name 'gs_load_pixelshader';
procedure gs_load_default_samplerstate(AIs3D: Boolean; AUnit: Integer); cdecl; external 'obs.dll' name 'gs_load_default_samplerstate';
function gs_get_vertex_shader: POBSGSShader; cdecl; external 'obs.dll' name 'gs_get_vertex_shader';
function gs_get_pixel_shader: POBSGSShader; cdecl; external 'obs.dll' name 'gs_get_pixel_shader';
function gs_get_color_space: TOBSGSColorSpace; cdecl; external 'obs.dll' name 'gs_get_color_space';
function gs_get_render_target: POBSGSTexture; cdecl; external 'obs.dll' name 'gs_get_render_target';
function gs_get_zstencil_target: POBSGSZStencil; cdecl; external 'obs.dll' name 'gs_get_zstencil_target';
procedure gs_set_render_target(ATexture: POBSGSTexture; AZStencil: POBSGSZStencil); cdecl; external 'obs.dll' name 'gs_set_render_target';
procedure gs_set_render_target_with_color_space(ATexture: POBSGSTexture; AZStencil: POBSGSZStencil; ASpace: TOBSGSColorSpace); cdecl; external 'obs.dll' name 'gs_set_render_target_with_color_space';
procedure gs_set_cube_render_target(ACubeTexture: POBSGSTexture; ASide: TOBSGSCubeSide; AZStencil: POBSGSZStencil); cdecl; external 'obs.dll' name 'gs_set_cube_render_target';
procedure gs_enable_framebuffer_srgb(AEnable: Boolean); cdecl; external 'obs.dll' name 'gs_enable_framebuffer_srgb';
function gs_framebuffer_srgb_enabled: Boolean; cdecl; external 'obs.dll' name 'gs_framebuffer_srgb_enabled';
function gs_get_linear_srgb: Boolean; cdecl; external 'obs.dll' name 'gs_get_linear_srgb';
function gs_set_linear_srgb(ALinearSrgb: Boolean): Boolean; cdecl; external 'obs.dll' name 'gs_set_linear_srgb';
procedure gs_copy_texture(ADst, ASrc: POBSGSTexture); cdecl; external 'obs.dll' name 'gs_copy_texture';
procedure gs_copy_texture_region(ADst: POBSGSTexture; ADstX, ADstY: Cardinal; ASrc: POBSGSTexture; ASrcX, ASrcY, ASrcW, ASrcH: Cardinal); cdecl; external 'obs.dll' name 'gs_copy_texture_region';
procedure gs_stage_texture(ADst: POBSGSStageSurface; ASrc: POBSGSTexture); cdecl; external 'obs.dll' name 'gs_stage_texture';
procedure gs_begin_frame; cdecl; external 'obs.dll' name 'gs_begin_frame';
procedure gs_begin_scene; cdecl; external 'obs.dll' name 'gs_begin_scene';
procedure gs_draw(AMode: TOBSGSDrawMode; AStartVert, ANumVerts: Cardinal); cdecl; external 'obs.dll' name 'gs_draw';
procedure gs_end_scene; cdecl; external 'obs.dll' name 'gs_end_scene';
procedure gs_load_swapchain(ASwapChain: POBSGSSwapChain); cdecl; external 'obs.dll' name 'gs_load_swapchain';
procedure gs_clear(AClearFlags: Cardinal; AColor: POBSVec4; ADepth: Single; AStencil: Byte); cdecl; external 'obs.dll' name 'gs_clear';
function gs_is_present_ready: Boolean; cdecl; external 'obs.dll' name 'gs_is_present_ready';
procedure gs_present; cdecl; external 'obs.dll' name 'gs_present';
procedure gs_flush; cdecl; external 'obs.dll' name 'gs_flush';
procedure gs_set_cull_mode(AMode: TOBSGSCullMode); cdecl; external 'obs.dll' name 'gs_set_cull_mode';
function gs_get_cull_mode: TOBSGSCullMode; cdecl; external 'obs.dll' name 'gs_get_cull_mode';
procedure gs_enable_blending(AEnable: Boolean); cdecl; external 'obs.dll' name 'gs_enable_blending';
procedure gs_enable_depth_test(AEnable: Boolean); cdecl; external 'obs.dll' name 'gs_enable_depth_test';
procedure gs_enable_stencil_test(AEnable: Boolean); cdecl; external 'obs.dll' name 'gs_enable_stencil_test';
procedure gs_enable_stencil_write(AEnable: Boolean); cdecl; external 'obs.dll' name 'gs_enable_stencil_write';
procedure gs_enable_color(ARed, AGreen, ABlue, AAlpha: Boolean); cdecl; external 'obs.dll' name 'gs_enable_color';
procedure gs_blend_function(ASrc, ADest: TOBSGSBlendType); cdecl; external 'obs.dll' name 'gs_blend_function';
procedure gs_blend_function_separate(ASrcC, ADestC, ASrcA, ADestA: TOBSGSBlendType); cdecl; external 'obs.dll' name 'gs_blend_function_separate';
procedure gs_blend_op(AOp: TOBSGSBlendOpType); cdecl; external 'obs.dll' name 'gs_blend_op';
procedure gs_depth_function(ATest: TOBSGSDepthTest); cdecl; external 'obs.dll' name 'gs_depth_function';
procedure gs_stencil_function(ASide: TOBSGSStencilSide; ATest: TOBSGSDepthTest); cdecl; external 'obs.dll' name 'gs_stencil_function';
procedure gs_stencil_op(ASide: TOBSGSStencilSide; AFail, AZFail, AZPass: TOBSGSStencilOpType); cdecl; external 'obs.dll' name 'gs_stencil_op';
procedure gs_set_viewport(AX, AY, AWidth, AHeight: Integer); cdecl; external 'obs.dll' name 'gs_set_viewport';
procedure gs_get_viewport(ARect: POBSGSRect); cdecl; external 'obs.dll' name 'gs_get_viewport';
procedure gs_set_scissor_rect(ARect: POBSGSRect); cdecl; external 'obs.dll' name 'gs_set_scissor_rect';
procedure gs_ortho(ALeft, ARight, ATop, ABottom, AZNear, AZFar: Single); cdecl; external 'obs.dll' name 'gs_ortho';
procedure gs_frustum(ALeft, ARight, ATop, ABottom, AZNear, AZFar: Single); cdecl; external 'obs.dll' name 'gs_frustum';
procedure gs_projection_push; cdecl; external 'obs.dll' name 'gs_projection_push';
procedure gs_projection_pop; cdecl; external 'obs.dll' name 'gs_projection_pop';
procedure gs_swapchain_destroy(ASwapChain: POBSGSSwapChain); cdecl; external 'obs.dll' name 'gs_swapchain_destroy';
procedure gs_texture_destroy(ATexture: POBSGSTexture); cdecl; external 'obs.dll' name 'gs_texture_destroy';
function gs_get_texture_type(ATexture: POBSGSTexture): TOBSGSTextureType; cdecl; external 'obs.dll' name 'gs_get_texture_type';
function gs_texture_map(ATexture: POBSGSTexture; APtr: PPByte; ALineSize: PCardinal): Boolean; cdecl; external 'obs.dll' name 'gs_texture_map';
procedure gs_texture_unmap(ATexture: POBSGSTexture); cdecl; external 'obs.dll' name 'gs_texture_unmap';
procedure gs_cubetexture_destroy(ACubeTexture: POBSGSTexture); cdecl; external 'obs.dll' name 'gs_cubetexture_destroy';
function gs_cubetexture_get_size(ACubeTexture: POBSGSTexture): Cardinal; cdecl; external 'obs.dll' name 'gs_cubetexture_get_size';
function gs_cubetexture_get_color_format(ACubeTexture: POBSGSTexture): TOBSGSColorFormat; cdecl; external 'obs.dll' name 'gs_cubetexture_get_color_format';
procedure gs_voltexture_destroy(AVolTexture: POBSGSTexture); cdecl; external 'obs.dll' name 'gs_voltexture_destroy';
function gs_voltexture_get_width(AVolTexture: POBSGSTexture): Cardinal; cdecl; external 'obs.dll' name 'gs_voltexture_get_width';
function gs_voltexture_get_height(AVolTexture: POBSGSTexture): Cardinal; cdecl; external 'obs.dll' name 'gs_voltexture_get_height';
function gs_voltexture_get_depth(AVolTexture: POBSGSTexture): Cardinal; cdecl; external 'obs.dll' name 'gs_voltexture_get_depth';
function gs_voltexture_get_color_format(AVolTexture: POBSGSTexture): TOBSGSColorFormat; cdecl; external 'obs.dll' name 'gs_voltexture_get_color_format';
procedure gs_zstencil_destroy(AZStencil: POBSGSZStencil); cdecl; external 'obs.dll' name 'gs_zstencil_destroy';
procedure gs_stagesurface_destroy(AStageSurface: POBSGSStageSurface); cdecl; external 'obs.dll' name 'gs_stagesurface_destroy';
function gs_stagesurface_get_width(AStageSurface: POBSGSStageSurface): Cardinal; cdecl; external 'obs.dll' name 'gs_stagesurface_get_width';
function gs_stagesurface_get_height(AStageSurface: POBSGSStageSurface): Cardinal; cdecl; external 'obs.dll' name 'gs_stagesurface_get_height';
function gs_stagesurface_get_color_format(AStageSurface: POBSGSStageSurface): TOBSGSColorFormat; cdecl; external 'obs.dll' name 'gs_stagesurface_get_color_format';
function gs_stagesurface_map(AStageSurface: POBSGSStageSurface; AData: PPByte; ALineSize: PCardinal): Boolean; cdecl; external 'obs.dll' name 'gs_stagesurface_map';
procedure gs_stagesurface_unmap(AStageSurface: POBSGSStageSurface); cdecl; external 'obs.dll' name 'gs_stagesurface_unmap';
procedure gs_samplerstate_destroy(ASamplerState: POBSGSSamplerState); cdecl; external 'obs.dll' name 'gs_samplerstate_destroy';
procedure gs_vertexbuffer_destroy(AVertBuffer: POBSGSVertBuffer); cdecl; external 'obs.dll' name 'gs_vertexbuffer_destroy';
procedure gs_vertexbuffer_flush(AVertBuffer: POBSGSVertBuffer); cdecl; external 'obs.dll' name 'gs_vertexbuffer_flush';
procedure gs_vertexbuffer_flush_direct(AVertBuffer: POBSGSVertBuffer; AData: POBSGSVBData); cdecl; external 'obs.dll' name 'gs_vertexbuffer_flush_direct';
function gs_vertexbuffer_get_data(AVertBuffer: POBSGSVertBuffer): POBSGSVBData; cdecl; external 'obs.dll' name 'gs_vertexbuffer_get_data';
procedure gs_indexbuffer_destroy(AIndexBuffer: POBSGSIndexBuffer); cdecl; external 'obs.dll' name 'gs_indexbuffer_destroy';
procedure gs_indexbuffer_flush(AIndexBuffer: POBSGSIndexBuffer); cdecl; external 'obs.dll' name 'gs_indexbuffer_flush';
procedure gs_indexbuffer_flush_direct(AIndexBuffer: POBSGSIndexBuffer; AData: Pointer); cdecl; external 'obs.dll' name 'gs_indexbuffer_flush_direct';
function gs_indexbuffer_get_data(AIndexBuffer: POBSGSIndexBuffer): Pointer; cdecl; external 'obs.dll' name 'gs_indexbuffer_get_data';
function gs_indexbuffer_get_num_indices(AIndexBuffer: POBSGSIndexBuffer): NativeUInt; cdecl; external 'obs.dll' name 'gs_indexbuffer_get_num_indices';
function gs_indexbuffer_get_type(AIndexBuffer: POBSGSIndexBuffer): TOBSGSIndexType; cdecl; external 'obs.dll' name 'gs_indexbuffer_get_type';
procedure gs_timer_destroy(ATimer: POBSGSTimer); cdecl; external 'obs.dll' name 'gs_timer_destroy';
procedure gs_timer_begin(ATimer: POBSGSTimer); cdecl; external 'obs.dll' name 'gs_timer_begin';
procedure gs_timer_end(ATimer: POBSGSTimer); cdecl; external 'obs.dll' name 'gs_timer_end';
function gs_timer_get_data(ATimer: POBSGSTimer; ATicks: PUInt64): Boolean; cdecl; external 'obs.dll' name 'gs_timer_get_data';
procedure gs_timer_range_destroy(ATimerRange: POBSGSTimerRange); cdecl; external 'obs.dll' name 'gs_timer_range_destroy';
procedure gs_timer_range_begin(ATimerRange: POBSGSTimerRange); cdecl; external 'obs.dll' name 'gs_timer_range_begin';
procedure gs_timer_range_end(ATimerRange: POBSGSTimerRange); cdecl; external 'obs.dll' name 'gs_timer_range_end';
function gs_timer_range_get_data(ATimerRange: POBSGSTimerRange; ADisjoint: PBoolean; AFrequency: PUInt64): Boolean; cdecl; external 'obs.dll' name 'gs_timer_range_get_data';
function gs_nv12_available: Boolean; cdecl; external 'obs.dll' name 'gs_nv12_available';
function gs_p010_available: Boolean; cdecl; external 'obs.dll' name 'gs_p010_available';
function gs_texture_create_nv12(ATexY, ATexUV: PPointer; AWidth, AHeight, AFlags: Cardinal): Boolean; cdecl; external 'obs.dll' name 'gs_texture_create_nv12';
function gs_texture_create_p010(ATexY, ATexUV: PPointer; AWidth, AHeight, AFlags: Cardinal): Boolean; cdecl; external 'obs.dll' name 'gs_texture_create_p010';
function gs_stagesurface_create_nv12(AWidth, AHeight: Cardinal): POBSGSStageSurface; cdecl; external 'obs.dll' name 'gs_stagesurface_create_nv12';
function gs_stagesurface_create_p010(AWidth, AHeight: Cardinal): POBSGSStageSurface; cdecl; external 'obs.dll' name 'gs_stagesurface_create_p010';
function gs_texture_get_width(ATexture: POBSGSTexture): Cardinal; cdecl; external 'obs.dll' name 'gs_texture_get_width';
function gs_texture_get_height(ATexture: POBSGSTexture): Cardinal; cdecl; external 'obs.dll' name 'gs_texture_get_height';
function gs_texture_get_color_format(ATexture: POBSGSTexture): TOBSGSColorFormat; cdecl; external 'obs.dll' name 'gs_texture_get_color_format';
function gs_texture_is_rect(ATexture: POBSGSTexture): Boolean; cdecl; external 'obs.dll' name 'gs_texture_is_rect';
function gs_texture_get_obj(ATexture: POBSGSTexture): Pointer; cdecl; external 'obs.dll' name 'gs_texture_get_obj';

implementation

end.
