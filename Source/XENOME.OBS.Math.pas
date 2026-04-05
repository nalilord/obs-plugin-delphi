unit XENOME.OBS.Math;

interface

uses
  XENOME.OBS.Types;

procedure quat_mul(ADst, AQ1, AQ2: POBSQuat); cdecl; external 'obs.dll' name 'quat_mul';
procedure quat_from_axisang(ADst: POBSQuat; AAxisAng: POBSAxisAng); cdecl; external 'obs.dll' name 'quat_from_axisang';
procedure quat_from_matrix3(ADst: POBSQuat; AMatrix: POBSMatrix3); cdecl; external 'obs.dll' name 'quat_from_matrix3';
procedure quat_from_matrix4(ADst: POBSQuat; AMatrix: POBSMatrix4); cdecl; external 'obs.dll' name 'quat_from_matrix4';
procedure quat_get_dir(ADst: POBSVec3; AQuat: POBSQuat); cdecl; external 'obs.dll' name 'quat_get_dir';
procedure quat_set_look_dir(ADst: POBSQuat; ADir: POBSVec3); cdecl; external 'obs.dll' name 'quat_set_look_dir';
procedure quat_log(ADst, AQuat: POBSQuat); cdecl; external 'obs.dll' name 'quat_log';
procedure quat_exp(ADst, AQuat: POBSQuat); cdecl; external 'obs.dll' name 'quat_exp';
procedure quat_interpolate(ADst, AQ1, AQ2: POBSQuat; AT: Single); cdecl; external 'obs.dll' name 'quat_interpolate';
procedure quat_get_tangent(ADst, APrev, AQuat, ANext: POBSQuat); cdecl; external 'obs.dll' name 'quat_get_tangent';
procedure quat_interpolate_cubic(ADst, AQ1, AQ2, AM1, AM2: POBSQuat; AT: Single); cdecl; external 'obs.dll' name 'quat_interpolate_cubic';

procedure axisang_from_quat(ADst: POBSAxisAng; AQuat: POBSQuat); cdecl; external 'obs.dll' name 'axisang_from_quat';

procedure vec3_from_vec4(ADst: POBSVec3; AVec: POBSVec4); cdecl; external 'obs.dll' name 'vec3_from_vec4';
function vec3_plane_dist(AVec: POBSVec3; APlane: POBSPlane): Single; cdecl; external 'obs.dll' name 'vec3_plane_dist';
procedure vec3_transform(ADst, AVec: POBSVec3; AMatrix: POBSMatrix4); cdecl; external 'obs.dll' name 'vec3_transform';
procedure vec3_rotate(ADst, AVec: POBSVec3; AMatrix: POBSMatrix3); cdecl; external 'obs.dll' name 'vec3_rotate';
procedure vec3_transform3x4(ADst, AVec: POBSVec3; AMatrix: POBSMatrix3); cdecl; external 'obs.dll' name 'vec3_transform3x4';
procedure vec3_mirror(ADst, AVec: POBSVec3; APlane: POBSPlane); cdecl; external 'obs.dll' name 'vec3_mirror';
procedure vec3_mirrorv(ADst, AVec, AMirrorVec: POBSVec3); cdecl; external 'obs.dll' name 'vec3_mirrorv';
procedure vec3_rand(ADst: POBSVec3; APositiveOnly: Integer); cdecl; external 'obs.dll' name 'vec3_rand';

procedure matrix3_from_quat(ADst: POBSMatrix3; AQuat: POBSQuat); cdecl; external 'obs.dll' name 'matrix3_from_quat';
procedure matrix3_from_axisang(ADst: POBSMatrix3; AAxisAng: POBSAxisAng); cdecl; external 'obs.dll' name 'matrix3_from_axisang';
procedure matrix3_from_matrix4(ADst: POBSMatrix3; AMatrix: POBSMatrix4); cdecl; external 'obs.dll' name 'matrix3_from_matrix4';
procedure matrix3_mul(ADst, AM1, AM2: POBSMatrix3); cdecl; external 'obs.dll' name 'matrix3_mul';
procedure matrix3_rotate(ADst, AMatrix: POBSMatrix3; AQuat: POBSQuat); cdecl; external 'obs.dll' name 'matrix3_rotate';
procedure matrix3_rotate_aa(ADst, AMatrix: POBSMatrix3; AAxisAng: POBSAxisAng); cdecl; external 'obs.dll' name 'matrix3_rotate_aa';
procedure matrix3_scale(ADst, AMatrix: POBSMatrix3; AVec: POBSVec3); cdecl; external 'obs.dll' name 'matrix3_scale';
procedure matrix3_transpose(ADst, AMatrix: POBSMatrix3); cdecl; external 'obs.dll' name 'matrix3_transpose';
procedure matrix3_inv(ADst, AMatrix: POBSMatrix3); cdecl; external 'obs.dll' name 'matrix3_inv';
procedure matrix3_mirror(ADst, AMatrix: POBSMatrix3; APlane: POBSPlane); cdecl; external 'obs.dll' name 'matrix3_mirror';
procedure matrix3_mirrorv(ADst, AMatrix: POBSMatrix3; AVec: POBSVec3); cdecl; external 'obs.dll' name 'matrix3_mirrorv';

procedure matrix4_from_matrix3(ADst: POBSMatrix4; AMatrix: POBSMatrix3); cdecl; external 'obs.dll' name 'matrix4_from_matrix3';
procedure matrix4_from_quat(ADst: POBSMatrix4; AQuat: POBSQuat); cdecl; external 'obs.dll' name 'matrix4_from_quat';
procedure matrix4_from_axisang(ADst: POBSMatrix4; AAxisAng: POBSAxisAng); cdecl; external 'obs.dll' name 'matrix4_from_axisang';
procedure matrix4_mul(ADst, AM1, AM2: POBSMatrix4); cdecl; external 'obs.dll' name 'matrix4_mul';
function matrix4_determinant(AMatrix: POBSMatrix4): Single; cdecl; external 'obs.dll' name 'matrix4_determinant';
procedure matrix4_translate3v(ADst, AMatrix: POBSMatrix4; AVec: POBSVec3); cdecl; external 'obs.dll' name 'matrix4_translate3v';
procedure matrix4_translate4v(ADst, AMatrix: POBSMatrix4; AVec: POBSVec4); cdecl; external 'obs.dll' name 'matrix4_translate4v';
procedure matrix4_rotate(ADst, AMatrix: POBSMatrix4; AQuat: POBSQuat); cdecl; external 'obs.dll' name 'matrix4_rotate';
procedure matrix4_rotate_aa(ADst, AMatrix: POBSMatrix4; AAxisAng: POBSAxisAng); cdecl; external 'obs.dll' name 'matrix4_rotate_aa';
procedure matrix4_scale(ADst, AMatrix: POBSMatrix4; AVec: POBSVec3); cdecl; external 'obs.dll' name 'matrix4_scale';
function matrix4_inv(ADst, AMatrix: POBSMatrix4): Boolean; cdecl; external 'obs.dll' name 'matrix4_inv';
procedure matrix4_transpose(ADst, AMatrix: POBSMatrix4); cdecl; external 'obs.dll' name 'matrix4_transpose';
procedure matrix4_translate3v_i(ADst: POBSMatrix4; AVec: POBSVec3; AMatrix: POBSMatrix4); cdecl; external 'obs.dll' name 'matrix4_translate3v_i';
procedure matrix4_translate4v_i(ADst: POBSMatrix4; AVec: POBSVec4; AMatrix: POBSMatrix4); cdecl; external 'obs.dll' name 'matrix4_translate4v_i';
procedure matrix4_rotate_i(ADst: POBSMatrix4; AQuat: POBSQuat; AMatrix: POBSMatrix4); cdecl; external 'obs.dll' name 'matrix4_rotate_i';
procedure matrix4_rotate_aa_i(ADst: POBSMatrix4; AAxisAng: POBSAxisAng; AMatrix: POBSMatrix4); cdecl; external 'obs.dll' name 'matrix4_rotate_aa_i';
procedure matrix4_scale_i(ADst: POBSMatrix4; AVec: POBSVec3; AMatrix: POBSMatrix4); cdecl; external 'obs.dll' name 'matrix4_scale_i';

procedure plane_from_tri(ADst: POBSPlane; AV1, AV2, AV3: POBSVec3); cdecl; external 'obs.dll' name 'plane_from_tri';
procedure plane_transform(ADst, APlane: POBSPlane; AMatrix: POBSMatrix4); cdecl; external 'obs.dll' name 'plane_transform';
procedure plane_transform3x4(ADst, APlane: POBSPlane; AMatrix: POBSMatrix3); cdecl; external 'obs.dll' name 'plane_transform3x4';
function plane_intersection_ray(APlane: POBSPlane; AOrigin, ADir: POBSVec3; AT: PSingle): Boolean; cdecl; external 'obs.dll' name 'plane_intersection_ray';
function plane_intersection_line(APlane: POBSPlane; AV1, AV2: POBSVec3; AT: PSingle): Boolean; cdecl; external 'obs.dll' name 'plane_intersection_line';
function plane_tri_inside(APlane: POBSPlane; AV1, AV2, AV3: POBSVec3; APrecision: Single): Boolean; cdecl; external 'obs.dll' name 'plane_tri_inside';
function plane_line_inside(APlane: POBSPlane; AV1, AV2: POBSVec3; APrecision: Single): Boolean; cdecl; external 'obs.dll' name 'plane_line_inside';

implementation

end.
