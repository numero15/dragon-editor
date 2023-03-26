extends Node3D
@export var skeleton: NodePath
@export var body_height_curve_path : NodePath
@export var body_width_curve_path : NodePath
@export var element_panel : NodePath
@export var movable_props : NodePath
const prop = preload("res://prop.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var _skel = get_node(skeleton)
	
	for _id in _skel.get_bone_count():
		var prop_instance = prop.instantiate()
		prop_instance.skel =_skel
		prop_instance.bone_id = _id
		prop_instance.dragon_gradient = _skel.get_parent().gradient
		prop_instance.element_panel = get_node(element_panel).get_path()
		prop_instance.connect("move_prop", get_node(movable_props).move_temp_prop)
		self.add_child(prop_instance)
		
func setup_props(button_pressed,_type, _parameter):
	if !button_pressed : return
	for _p in get_children():
		_p.setup(_type, _parameter)
		
func scale():
	var body_width_curve_3d = get_node(body_width_curve_path).curve
	var body_height_curve_3d = get_node(body_height_curve_path).curve
	var _skel = get_node(skeleton)

	for _p in get_children():
		var sample_x = body_width_curve_3d.sample_baked(_p.bone_id/float(_skel.get_bone_count()) * -body_width_curve_3d.get_point_position(body_width_curve_3d.point_count-1).z)
		var sample_y = body_height_curve_3d.sample_baked(_p.bone_id/float(_skel.get_bone_count()) * -body_height_curve_3d.get_point_position(body_height_curve_3d.point_count-1).z)
		_p.scale(sample_x,sample_y)



