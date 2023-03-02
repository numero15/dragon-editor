extends Node3D
@onready var body = get_node("Body_procedural")
@onready var props = get_node("Props")
@onready var manager = get_node("SkeletonManager")

func _ready():
	remesh()

func remesh():
	body.remesh()
	props.scale()

func play():
	manager.play = true
	
func stop():
	manager.play = false
