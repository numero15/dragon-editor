extends StaticBody3D
@export var target : NodePath

@export var horizontal : bool = false
var button_pressed : bool = false
signal target_moved()

func _ready():
	connect("input_event", _on_PickArea_input_event)
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed :
				button_pressed = true
			else:
				button_pressed = false

func _on_PickArea_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int):	
	if get_node_or_null(target) ==null or !button_pressed :return	
	move_target(_position)	
	emit_signal("target_moved",get_node(target).global_transform.origin)
	
func move_target(_pos:Vector3):
	if !horizontal:
		get_node(target).global_transform.origin.y=_pos.y - position.y
		get_node(target).global_transform.origin.z= _pos.z - position.z
	if horizontal:
		get_node(target).global_transform.origin.x=_pos.x - position.x
		get_node(target).global_transform.origin.z= _pos.z - position.z
