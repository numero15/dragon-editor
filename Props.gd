extends Node3D
@export var skeleton: NodePath
@export var body_curve_path : NodePath
const prop = preload("res://prop.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var _skel = get_node(skeleton)
	for _id in _skel.get_bone_count():
		var prop_instance = prop.instantiate()
		prop_instance.skel_path =_skel.get_path()
		prop_instance.bone_id = _id
		prop_instance.body_curve_path = get_node(body_curve_path)

		self.add_child(prop_instance)
		
func scale():
	var body_curve_3d = get_node(body_curve_path).curve
	var _skel = get_node(skeleton)

	for _p in get_children():
		var sample = body_curve_3d.sample_baked(_p.bone_id/float(_skel.get_bone_count()) * -body_curve_3d.get_point_position(body_curve_3d.point_count-1).z)
		_p.scale(sample)



