extends CanvasLayer
var targets : Array
var prev_value : float

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func _on_close_button_up():
	visible = false

func _on_slider_scale_drag_ended(value):
	for _t in targets :
#		_t.rotate_x(value-prev_value)
		
		for _c in _t.get_children() :
			_c.transform = _c.transform.orthonormalized()
			_c.transform = _c.transform.scaled(Vector3(value,value, value))
#	prev_value = value
