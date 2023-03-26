extends Node3D
var skel : Node
var bone_id : int = 0
var element_panel
@onready var ring = $ring
@onready var collison = $CollisionShape3D
@onready var wing_left = $wing_left
@onready var wing_right = $wing_right
#@onready var leg_left = $leg_left
#@onready var leg_right = $leg_right
@onready var fx = $FX
@onready var greeble = $Greeble
@onready var greeble_multimesh = $MultiMeshGreeble
@onready var sound_fx = $AudioStreamPlayer
var scale_x : float
var scale_y : float
var type_to_add : String = ""
var element_to_add : Resource = null
var dragon_gradient: GradientTexture1D

#signal move_prop(_pos:Vector3, _transform:RemoteTransform3D)
signal move_prop(_pos:Vector3, _bone_id:int, _bind: String, _node:Resource)
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("input_event", _on_PickArea_input_event)
	ring.visible = false
#	leg_left.visible = false
	greeble_multimesh.visible = false
		
func setup(_type, _parameter):
	type_to_add = _type
	element_to_add = _parameter
	
func _process(_delta):
	if bone_id >=skel.get_bone_count():
		visible = false
		return
	else :
		visible=true		
	transform = skel.get_bone_global_pose(bone_id)

func scale(_sx,_sy):
	scale_y = abs(_sy.y)
	scale_x = abs(_sx.x)
	ring.transform = ring.transform.orthonormalized()
	var basis = Basis()
	basis.x = Vector3(1, 0, 0)
	basis.y = Vector3(0, 1, 0)
	basis.z = Vector3(0, 0, 1)
	ring.transform.basis = basis	
	ring.rotate_x(PI/2)
	ring.transform.origin= Vector3.ZERO
	ring.transform = ring.transform.scaled(Vector3(scale_x,scale_y,1))
	ring.transform.origin.y= -scale_y*.6
	
#	leg_left.transform = leg_left.transform.orthonormalized()	
#	leg_left.transform.origin= Vector3.ZERO
#	leg_left.transform.basis= basis
#	leg_left.translate(Vector3(cos(-PI/5)*scale_x,sin(-PI/5)*scale_y-scale_y*.6,0.0))
#
#	leg_right.transform = leg_right.transform.orthonormalized()
#	leg_right.transform.origin= Vector3.ZERO
#	leg_right.transform.basis= basis
#	leg_right.transform = leg_right.transform.scaled(Vector3(-1,1,1))
#	leg_right.translate(Vector3(cos(-PI/5)*scale_x,sin(-PI/5)*scale_y-scale_y*.6,0.0))

	collison.transform = collison.transform.orthonormalized()		
#	add 0.01 to avoid scale equal 0
	collison.transform = collison.transform.scaled(Vector3(scale_x+0.01,scale_y+0.01,1))
	collison.transform.origin= Vector3.ZERO
	collison.transform.origin.y= -scale_y*.6
	
	var _c : float = bone_id/float(skel.get_bone_count())
	greeble_multimesh.setup(greeble.mesh, 80, dragon_gradient.gradient.sample(_c), scale_x, scale_y)


#connecté à lui même et aux différents éléments
func _on_PickArea_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int, _bind: String =""):

	emit_signal("move_prop", Vector3(cos(-PI/5)*scale_x,sin(-PI/5)*scale_y-scale_y*.6,_position.z-self.position.z), bone_id)

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and element_to_add != null:
				ring.visible = true
				greeble_multimesh.visible = false
				if type_to_add == "ring" and ring.get_child_count() != 0:
					pass
				elif type_to_add == "ring" and ring.get_child_count() == 0:
					add_element (ring, 'ring')
					start_fx()
					
#				if _bind == "leg" and leg_right.get_child_count() != 0:
#					get_node(element_panel).visible = true
#					get_node(element_panel).targets = [leg_left, leg_right]
#
#				if type_to_add == "leg" and leg_right.get_child_count() == 0:
#					add_element (leg_right, 'leg')
#					add_element (leg_left, 'leg')
#					start_fx()
		
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed and ring.visible:
				sound_fx.pitch_scale = 0.5 + bone_id/20.0
				sound_fx.playing = true
				if _bind =="ring":
					remove_element(ring)
					greeble_multimesh.visible = true
					start_fx()
#				if _bind =="leg":
#					remove_element(leg_left)
#					remove_element(leg_right)
#					start_fx()

func add_element (_parent, _bind):
	_parent.visible = true
	for n in _parent.get_children():
		_parent.remove_child(n)
	_parent.add_child(element_to_add.instantiate())
	_parent.get_child(0).connect("input_event", _on_PickArea_input_event.bind(_bind))
	_parent.get_child(0).connect("mouse_entered", _on_mouse_entered)
	_parent.get_child(0).connect("mouse_exited", _on_mouse_exited)

func remove_element (_parent):
	_parent.visible = false
	for n in _parent.get_children():		
		_parent.get_child(0).disconnect("input_event", _on_PickArea_input_event)
		_parent.get_child(0).disconnect("mouse_entered", _on_mouse_entered)
		_parent.get_child(0).disconnect("mouse_exited", _on_mouse_exited)
		_parent.remove_child(n)
	
func start_fx() :
	sound_fx.pitch_scale = 0.5 + bone_id/20.0
	sound_fx.playing = true
	fx.amount = scale_x*30+5
	fx.transform = fx.transform.orthonormalized()	
	fx.transform.origin= Vector3.ZERO
	fx.transform.origin.y= -scale_x*.6
	fx.process_material.emission_ring_inner_radius = scale_x*1.5-.1
	fx.process_material.emission_ring_radius = scale_x*1.5
	fx.restart()

func _on_mouse_entered():
	get_tree().call_group("dragon", "stop")
	get_tree().call_group("dragon", "set_mouse_over", true)

func _on_mouse_exited():
	get_tree().call_group("dragon", "play")
	get_tree().call_group("dragon", "set_mouse_over", false)
