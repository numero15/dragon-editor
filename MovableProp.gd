extends Node3D
var bone_id : int = 0
var skel
var is_moving = false
@export var is_temp : bool = false
@onready var control_ray = $Control/DotPosition/RayCast3D
@onready var area_detection = $Control/AreaDetection
@onready var dot_position = $Control/DotPosition
var dragging = false
var hover = false
var pos : Vector3
signal is_editing
signal is_not_editing

func _ready():
	area_detection.connect("target_moved",control_target_moved)
func _process(delta):
	if is_moving : 
		get_child(1).transform = skel.get_bone_global_pose(bone_id)
		get_child(1).translate(pos)
		control_ray.get_parent().global_transform.origin = area_detection.get_child(1).global_transform.origin
		control_ray.get_parent().position.x = 0
		
	if is_temp or skel ==null or is_moving : 
		return
	if bone_id >=skel.get_bone_count():
		visible = false
		return
	else :
		visible=true
	
	get_child(0).transform = skel.get_bone_global_pose(bone_id)
	get_child(0).translate(pos)
	get_child(1).transform = skel.get_bone_global_pose(bone_id)
	get_child(1).translate(pos)

func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			pass
#			queue_free()


func _on_control_mouse_entered():
	get_tree().call_group("dragon", "stop")
	get_tree().call_group("dragon", "set_mouse_over", true)
	emit_signal("is_editing")
	area_detection.visible = true

func _on_control_mouse_exited():	
	if !is_moving :
		get_tree().call_group("dragon", "play")
		get_tree().call_group("dragon", "set_mouse_over", false)
		emit_signal("is_not_editing")
		area_detection.get_child(0).visible = false
		dot_position.get_child(0).disabled = false
		area_detection.visible = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if !event.pressed :
				is_moving = false
				area_detection.get_child(0).visible = false
				dot_position.get_child(0).disabled = false
				area_detection.visible = false
				control_ray.get_parent().position.y = 0
				control_ray.get_parent().position.z = 0
				
func _on_control_input_event(camera, event, position, normal, shape_idx):		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed :
				is_moving = true
				area_detection.get_child(0).visible = true
				dot_position.get_child(0).disabled = true
				area_detection.move_target(position)
				emit_signal("is_editing")

func control_target_moved (event):
		
	if is_moving:		
		if control_ray.is_colliding() :
			bone_id = control_ray.get_collider().bone_id
			pos.z = control_ray.get_collider().to_local(control_ray.get_collision_point()).z
#			transform = skel.get_bone_global_pose(bone_id)
#	if event is InputEventMouseMotion:
#
#		bone_id = control_ray.get_collider().bone_id
#			var new_pos = control_ray.get_collider().to_local(control_ray.get_collision_point())
#	control_ray.get_parent().transform = area_detection.get_child(1).transform
#			get_child(1).transform = get_child(1).transform.orthonormalized()
#			get_child(1).transform.origin=Vector3.ZERO
#			get_child(1).position.z=new_pos.z
#			get_child(1).transform = skel.get_bone_global_pose(bone_id)
#			get_child(0).transform.origin=Vector3.ZERO



#	if event is InputEventMouseButton:
#		if event.button_index == MOUSE_BUTTON_LEFT:
			
			
