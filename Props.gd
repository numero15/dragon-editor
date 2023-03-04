extends Node3D
@export var skeleton: NodePath
@export var body_curve_path : NodePath
const prop = preload("res://prop.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var _skel = get_node(skeleton)
	for _id in _skel.get_bone_count():
		var prop_instance = prop.instantiate()
		prop_instance.skel =_skel
		prop_instance.bone_id = _id
		prop_instance.body_curve = get_node(body_curve_path)
		self.add_child(prop_instance)
		
func setup_props(button_pressed,_type, _parameter):
	if !button_pressed : return
	for _p in get_children():
		_p.setup(_type, _parameter)
		
func scale():
	var body_curve_3d = get_node(body_curve_path).curve
	var _skel = get_node(skeleton)

	for _p in get_children():
		var sample = body_curve_3d.sample_baked(_p.bone_id/float(_skel.get_bone_count()) * -body_curve_3d.get_point_position(body_curve_3d.point_count-1).z)
		_p.scale(sample)



