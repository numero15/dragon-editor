extends StaticBody3D

var point_id : int
var curve : NodePath
var target : NodePath
var dragging = false
var hover = false


func _ready():
	connect("input_event", _on_PickArea_input_event)
	
func _on_PickArea_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int):
	if event is InputEventMouseMotion and dragging :
		hover = true

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed :
				dragging = true
			elif hover:
				dragging = false
				hover = false
				get_tree().call_group("dragon", "remesh")
			else :
				dragging = false
		
	if dragging and hover and event is InputEventMouseMotion :
		var tween = get_tree().create_tween()
		tween.tween_method(set_pos, get_node(curve).curve.get_point_position(point_id), get_node(target).transform.origin, .2)

func set_pos(value: Vector3):
	if value.y>-.5 :
		value.y = -.5
	if value.y<-4 :
		value.y = -4
	
	get_node(curve).curve.set_point_position(point_id,value)	
	transform.origin = value
	
	
		




