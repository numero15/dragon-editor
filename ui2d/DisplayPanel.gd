extends Node3D

var mesh_size
@onready var viewport = $SubViewport
@onready var panel_face = $MeshInstance3D
@onready var touch_area = $MeshInstance3D/Area3D

var is_mouse_pressed : bool = false
var is_mouse_inside : bool = false
var last_mouse_position3D = null
var last_mouse_position2D = null

func _input(event):
	var is_mouse_event
	if event is InputEventMouseButton or event is InputEventMouseMotion :
		is_mouse_event = true
	if is_mouse_event:
		handle_mouse(event)
	elif not is_mouse_event :
		viewport.event(event)
		
func handle_mouse(event):
	if event is InputEventMouseButton :
		is_mouse_pressed = true
	var mouse_pos3D = find_mouse(event.global_position)
	is_mouse_inside = mouse_pos3D != null
	if is_mouse_inside :
		mouse_pos3D = touch_area.global_transform.affine_inverse() * mouse_pos3D
	else  : 
		mouse_pos3D = last_mouse_position3D
		if mouse_pos3D == null :
			mouse_pos3D = Vector3.ZERO
			
	var mouse_pos2D = Vector2(mouse_pos3D.x, - mouse_pos3D.y)
	mouse_pos2D.x += mesh_size.x / 2
	mouse_pos2D.y += mesh_size.y / 2
	
	mouse_pos2D.x = mouse_pos2D.x/mesh_size.x
	mouse_pos2D.y = mouse_pos2D.ymesh_size.y
	
func find_mouse (global_position):
	pass

func _on_area_3d_mouse_entered():
	is_mouse_inside = true
