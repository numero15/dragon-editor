extends Node3D


@export_range(0,1,0.01) var dampening : float = 0
@export var distance_strength : Curve
@export var oscillator : Curve
@export var is_oscillator : bool = false

var pos_in_oscillator : float = 0.0
var modifier_before = null
var modifier_after = null

var chain_length : float
var skeleton : NodePath
var bone_id : int
var speed : float = 0.2
var delay : float = .5

var prev_node = null
var next_node = null

func _ready():
	transform.origin = get_node(skeleton).get_bone_global_pose(bone_id).origin
#	transform.origin = get_node(skeleton).get_bone_global_pose(bone_id).origin
	transform.origin.y = 0

func check_modifiers(_modifiers):
	for modifier in _modifiers :
		if modifier.bone_id < bone_id :
			if modifier_before == null : modifier_before = modifier
			elif modifier_before.bone_id < modifier.bone_id  : modifier_before = modifier
			
		if modifier.bone_id > bone_id :
			if modifier_after == null : modifier_after = modifier
			elif modifier_after.bone_id > modifier.bone_id  : modifier_after = modifier

func update(delta):
	transform = transform.orthonormalized()
	if prev_node!=null :
		look_at(prev_node.global_transform.origin, Vector3(0,1,0))
	assign_position()
	
#	var distance : float
#	var strength : float
	
	if is_oscillator and dampening == 0:
		pos_in_oscillator +=delta*speed
		if pos_in_oscillator >= 1 : 
			pos_in_oscillator = pos_in_oscillator - 1
		transform.origin.y = oscillator.sample(pos_in_oscillator)
		return
	
	if dampening != 0: return

	if modifier_after == null and modifier_before != null :
		transform.origin.y =compute_position(modifier_before)

	
	if modifier_after != null and modifier_before == null :
		transform.origin.y =compute_position(modifier_after)

		
	if modifier_after != null and modifier_before != null :
		
		var pos_after : float = compute_position(modifier_after)
		var pos_before : float = compute_position(modifier_before)
		var dist_after : float = abs(bone_id - modifier_after.bone_id)/chain_length
		var dist_before : float = abs(bone_id - modifier_before.bone_id)/chain_length
		var total_strength =  dist_before + dist_after
		transform.origin.y = pos_before*(dist_after/total_strength) + pos_after*(dist_before/total_strength)
		
func compute_position(_modifier):
	
	if _modifier.dampening > 0 : 
		return 0
	var distance : float = _modifier.pos_in_oscillator - abs(bone_id - _modifier.bone_id)/chain_length*delay
	distance = abs(distance)
	if distance <= 0 :
		distance+=1.0
		
	if distance >= 1 :
		distance-=1.0
	var strength: float = 1 + _modifier.distance_strength.sample(abs(bone_id - _modifier.bone_id)/chain_length)
	return  _modifier.oscillator.sample(distance) * strength

func assign_position():
	var _skel = get_node(skeleton)
	var rest = _skel.get_bone_rest(bone_id)
	var g_tr = _skel.get_bone_global_pose(bone_id)
	var newpose = rest

#https://stackoverflow.com/questions/15022630/how-to-calculate-the-angle-from-rotation-matrix

#	newpose = newpose.rotated(Vector3(1.0, 0.0, 0.0), _angle.x - atan2(g_tr.basis.y.z,g_tr.basis.z.z) + PI/2)
#	newpose = newpose.rotated(Vector3(0.0, 1.0, 0.0), _angle.y)
#	newpose = newpose.rotated(Vector3(0.0, 0.0, 1.0), _angle.z)
	
#	newpose = newpose.rotated(Vector3(1.0, 0.0, 0.0), - atan2(g_tr.basis.y.z,g_tr.basis.z.z) + PI/2)
#	newpose = newpose.rotated(Vector3(0.0, 1.0, 0.0), _angle.y)
#	newpose = newpose.rotated(Vector3(0.0, 0.0, 1.0), _angle.z)

	newpose = transform.orthonormalized()
	newpose = newpose.rotated(Vector3(1.0, 0.0, 0.0), - atan2(g_tr.basis.y.z,g_tr.basis.z.z))
#	newpose = newpose*Transform3D.FLIP_X
	
	_skel.set_bone_pose_rotation(bone_id, newpose.basis.get_rotation_quaternion().normalized())



