extends Node3D
@onready var body = get_node("Body_procedural")
@onready var props = get_node("Props")
@onready var manager = get_node("SkeletonManager")
@onready var movable_props = get_node("MovableProps")
@onready var camera = get_node("../CameraTarget/SpringArm3D/Camera3D")
var mouse_over : bool = false
var length = 20
signal length_changed

func _ready():
	remesh()
	emit_signal("length_changed",length)
	
func _process(delta):
	if Input.is_action_just_pressed("length_up"):
		length = length + 1
		change_length(length)
		props.scale()
		emit_signal("length_changed",length)
		
	if Input.is_action_just_pressed("length_down"):
		length = length - 1
		change_length(length)
		props.scale()
		emit_signal("length_changed",length)
	
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 100
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.collision_mask = 16
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	var raycast_result = space.intersect_ray(ray_query)
#	if raycast_result:
#		print(raycast_result.collider)

		
func change_length(_l : int ) :
	body.change_length(_l)
	
func remesh():
	body.remesh(length)
	props.scale()

func play():
	manager.play = true
	
func stop():
	manager.play = false
	
func set_mouse_over(_m:bool):
	mouse_over = _m
	movable_props.temp_visible = mouse_over
	
