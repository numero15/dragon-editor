extends StaticBody3D
@onready var target = get_node("DragTarget")
@export var horizontal : bool = false
func _ready():
	connect("input_event", _on_PickArea_input_event)


func _on_PickArea_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int):
	if event is InputEventMouseMotion and !horizontal:
		target.global_transform.origin.y=_position.y
		target.global_transform.origin.z= _position.z
	if event is InputEventMouseMotion and horizontal:
		target.global_transform.origin.x=_position.x
		target.global_transform.origin.z= _position.z
