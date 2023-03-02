extends Node3D
@export var skel_path : NodePath
@export var bone_id : int = 0
var body_curve_path
@onready var model = $ring
@onready var collison = $collisonBody
@onready var wing = $wing
#var p : float


# Called when the node enters the scene tree for the first time.
func _ready():
#	bone_idx = bone_id
#	set_external_skeleton(skel_path)
#	set_use_external_skeleton(true)
	collison.connect("input_event", _on_PickArea_input_event)
	
func _process(_delta):
	transform = get_node(skel_path).get_bone_global_pose(bone_id)

func scale(_s):
	model.transform = model.transform.orthonormalized()	
	model.transform.origin= Vector3.ZERO
	model.transform = model.transform.scaled(Vector3(-_s.y*2.1,-_s.y*2.1,4))
	collison.transform = collison.transform.orthonormalized()	
	collison.transform.origin= Vector3.ZERO
#	add 0.01 to avoid scale equal 0
	collison.transform = collison.transform.scaled(Vector3(abs(_s.y)+0.01,abs(_s.y)+0.01,1))
	place_element(wing, _s)

func place_element(_e,_s):
	_e.position.y=-_s.y


func _on_PickArea_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int):
	if event is InputEventMouseMotion :
		if _normal.y>0 : 
			wing.visible = true
		if _normal.y<0 :
			wing.visible = false

func _on_collison_body_mouse_entered():
	get_tree().call_group("dragon", "stop")
	pass


func _on_collison_body_mouse_exited():
	get_tree().call_group("dragon", "play")
	wing.visible = false
