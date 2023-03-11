extends Area2D

signal clicked

var held = false
var prev_neighbor : Node2D = null
var next_neighbor : Node2D = null

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("clicked", self)

func _physics_process(delta):
	if held:
		if prev_neighbor == null or next_neighbor == null :
			global_transform.origin.y = get_global_mouse_position().y
		else :
			global_transform.origin = get_global_mouse_position()
			if transform.origin.x < prev_neighbor.transform.origin.x + 20 :
				transform.origin.x =  prev_neighbor.transform.origin.x + 20
			if  transform.origin.x >next_neighbor.transform.origin.x - 20 :
				transform.origin.x  = next_neighbor.transform.origin.x - 20
				
func pickup():
	if held:
		return
	held = true

func drop():
	if held:
		held = false
