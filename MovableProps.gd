extends Node3D
@export var skel : NodePath
@export var body_height_curve_path : NodePath
@export var body_width_curve_path : NodePath
@onready var tempProp = $TempLegContainer/MovableProp
@onready var legs = $Legs
var temp_visible : bool
var bone_id : int
var pos : Vector3
var type : String
var prop= preload("res://movable_prop.tscn")
var prop_content : Resource = null
signal reset_prop_selected()

func _ready():
	for n in tempProp.get_children():
		tempProp.remove_child(n)

func _process(delta):
	tempProp.visible = temp_visible
	
func _input(event):
	if event.is_action_released("UI_click"):
		
		if prop_content == null or !tempProp.visible : return
		var prop_instance  = prop.instantiate()
		prop_instance.skel = get_node(skel)
		prop_instance.bone_id = bone_id
		prop_instance.pos = pos
		prop_instance.connect("is_editing",disable_temp_prop)
		prop_instance.connect("is_not_editing",enable_temp_prop)
		legs.add_child(prop_instance)
		#supprime le modèle de la prop mais pas son module de controle
		prop_instance.remove_child(prop_instance.get_child(1))
		prop_instance.get_child(0).translate(pos)
		prop_instance.get_child(0).position.x = 0
		prop_instance.get_child(0).get_child(0).visible = false
		
		var prop_content_instance = prop_content.instantiate()
		prop_content_instance.transform = get_node(skel).get_bone_global_pose(bone_id)
		prop_content_instance.translate(pos)
#		prop_instance.dragon_gradient = _skel.get_parent().gradient
#		prop_instance.element_panel = get_node(element_panel).get_path()
			
		prop_content_instance.connect("input_event", prop_instance._on_area_3d_input_event)
		prop_instance.add_child(prop_content_instance)

func setup_props(button_pressed,_type, _parameter):
	if !button_pressed : return
	type = _type
	prop_content = _parameter
	for n in tempProp.get_children():
		tempProp.remove_child(n)
	
	tempProp.add_child(prop_content.instantiate())
	tempProp.get_child(0).input_ray_pickable = false

		
func reset_temp_prop():
	pass
	
func disable_temp_prop():
	temp_visible = false
	
func enable_temp_prop():
	temp_visible = true

func move_temp_prop(_pos:Vector3 = Vector3.ZERO, _bone_id : int = 0) :
	bone_id = _bone_id
	tempProp.transform = get_node(skel).get_bone_global_pose(_bone_id)
	tempProp.translate(_pos)
	pos = _pos
	
func scale():
	var body_width_curve_3d = get_node(body_width_curve_path).curve
	var body_height_curve_3d = get_node(body_height_curve_path).curve
	var _skel = get_node(skel)

	for _p in legs.get_children():
		var sample_x = body_width_curve_3d.sample_baked(_p.bone_id/float(_skel.get_bone_count()) * -body_width_curve_3d.get_point_position(body_width_curve_3d.point_count-1).z)
		var sample_y = body_height_curve_3d.sample_baked(_p.bone_id/float(_skel.get_bone_count()) * -body_height_curve_3d.get_point_position(body_height_curve_3d.point_count-1).z)
		_p.scale(sample_x,sample_y)

