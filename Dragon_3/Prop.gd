extends Node3D
var skel : Node
var bone_id : int = 0
var body_curve : Node
@onready var model = $MeshInstance3D
@onready var collison = $collisonBody
@onready var wing = $wing
@onready var leg_left = $leg_left/leg01/Cylinder004
@onready var fx = $FX
var s

# Called when the node enters the scene tree for the first time.
func _ready():
	collison.connect("input_event", _on_PickArea_input_event)
	model.visible = false
	wing.visible = false
	leg_left.visible = false
		
func setup(_type, _parameters):
	print(_type)
	
func _process(_delta):
	transform = skel.get_bone_global_pose(bone_id)

func scale(_s):
	model.transform = model.transform.orthonormalized()
	var basis = Basis()
	# Contains the following default values:
	basis.x = Vector3(1, 0, 0) # Vector pointing along the X axis
	basis.y = Vector3(0, 1, 0) # Vector pointing along the Y axis
	basis.z = Vector3(0, 0, 1) # Vector pointing along the Z axis
	model.transform.basis = basis
	model.rotate_x(PI/2)
	model.transform.origin= Vector3.ZERO
	model.translate(Vector3(0.0,0.0,0.5))
	model.transform = model.transform.scaled(Vector3(abs(_s.y),abs(_s.y),1))
	
	leg_left.transform = leg_left.transform.orthonormalized()	
	leg_left.transform.origin= Vector3.ZERO
	leg_left.translate(Vector3(-_s.y*.2,_s.y*.3,0.0))
	leg_left.transform = leg_left.transform.scaled(Vector3(3.0,3.0,3.0))

	collison.transform = collison.transform.orthonormalized()	
	collison.transform.origin= Vector3.ZERO
	collison.transform.origin.y= -abs(_s.y)*.6	
#	add 0.01 to avoid scale equal 0
	collison.transform = collison.transform.scaled(Vector3(abs(_s.y)+0.01,abs(_s.y)+0.01,1))
	
	var _m : PrimitiveMesh = SphereMesh.new()
#	_m.radial_segments = 12
#	_m.rings = 6
#	_m.radius = abs(_s.y)/2.0 +.3
#	_m.height = abs(_s.y) +.6
#	fx.draw_pass_1 = _m
	s = abs(_s.y)
	
	
	place_element(wing, _s)

func place_element(_e,_s):
	_e.position.y=-_s.y


func _on_PickArea_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int):
#	if event is InputEventMouseMotion :
#		if _normal.y>0 : 
#			wing.visible = true
#		if _normal.y<0 :
#			wing.visible = false
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				model.visible = !model.visible

				fx.amount = s*10+5
				fx.transform = fx.transform.orthonormalized()	
				fx.transform.origin= Vector3.ZERO
				fx.transform.origin.y= -s*.6
				fx.process_material.emission_ring_inner_radius = s-.1
				fx.process_material.emission_ring_radius = s
				fx.restart()

func _on_collison_body_mouse_entered():
	get_tree().call_group("dragon", "stop")
	pass


func _on_collison_body_mouse_exited():
	get_tree().call_group("dragon", "play")
	wing.visible = false
