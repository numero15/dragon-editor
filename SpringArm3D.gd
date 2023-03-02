extends SpringArm3D

@export var mouse_sensitivity : float = 0.2
@export var min_length : float = 5
@export var max_length : float = 50

var dragging = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				dragging = true
			else :
				dragging = false
			
	if dragging and event is InputEventMouseMotion :
		var _r_x = rotation_degrees.x
		_r_x = event.relative.y * mouse_sensitivity
		rotation_degrees.x += _r_x
		rotation_degrees.x = clamp( rotation_degrees.x, -90.0,90.0)
		
		var _r_y = rotation_degrees.y
		_r_y = event.relative.x * mouse_sensitivity
		rotation_degrees.y += _r_y
#		rotation_degrees.y = wrapf( rotation_degrees.y, 0.0,360.0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_released("UI_wheel_down"):
		spring_length = spring_length-3
	if Input.is_action_just_released("UI_wheel_up"):
		spring_length = spring_length+3
	if spring_length > max_length : spring_length =max_length
	if spring_length < min_length : spring_length =min_length
