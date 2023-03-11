extends Node3D
@onready var body = get_node("Body_procedural")
@onready var props = get_node("Props")
@onready var manager = get_node("SkeletonManager")
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
		
func change_length(_l : int ) :
	body.change_length(_l)
	
func remesh():
	body.remesh(length)
	props.scale()

func play():
	manager.play = true
	
func stop():
	manager.play = false
