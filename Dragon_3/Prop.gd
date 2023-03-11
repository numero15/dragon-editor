extends Node3D
var skel : Node
var bone_id : int = 0
#var body_height_curve : Node
@onready var ring = $ring
@onready var collison = $collisonBody
@onready var wing = $wing
@onready var leg_left = $leg_left
@onready var fx = $FX
@onready var greeble = $Greeble
@onready var greeble_multimesh = $MultiMeshGreeble
@onready var sound_fx = $AudioStreamPlayer
var scale_x : float
var scale_y : float
var wing_to_add : Resource = null
var ring_to_add : Resource = null
var leg_to_add : Resource = null
var dragon_gradient: GradientTexture1D

# Called when the node enters the scene tree for the first time.
func _ready():
	collison.connect("input_event", _on_PickArea_input_event)
	ring.visible = false
	wing.visible = false
	leg_left.visible = false
		
func setup(_type, _parameter):
	if _type == 'ring' :
		ring_to_add = _parameter
	
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
	ring.translate(Vector3(0.0,0.0,0.5))
	ring.transform = ring.transform.scaled(Vector3(scale_x,scale_y,1))
	
	leg_left.transform = leg_left.transform.orthonormalized()	
	leg_left.transform.origin= Vector3.ZERO
	leg_left.translate(Vector3(cos(-PI/10)*scale_x,sin(-PI/10)*scale_y-scale_y*.6,0.0))
#	leg_left.transform = leg_left.transform.scaled(Vector3(s*2.0,s*2.0,s*2.0))

	collison.transform = collison.transform.orthonormalized()	
	collison.transform.origin= Vector3.ZERO
	collison.transform.origin.y= -scale_y*.6	
#	add 0.01 to avoid scale equal 0
	collison.transform = collison.transform.scaled(Vector3(scale_x+0.01,scale_y+0.01,1))

	
	greeble_multimesh.multimesh = MultiMesh.new()
	greeble_multimesh.multimesh.mesh = greeble.mesh
	greeble_multimesh.multimesh.resource_local_to_scene = true
#	définir la première couleur du dégradé
	greeble_multimesh.material_override.resource_local_to_scene = true
	var _gt = greeble_multimesh.material_override.get_shader_parameter("gradient")
	var _c : float = bone_id/float(skel.get_bone_count())
	_gt.resource_local_to_scene = true
	_gt.gradient.resource_local_to_scene = true
	var _g : Gradient = greeble_multimesh.material_override.get_shader_parameter("gradient").gradient.duplicate(true)
	_g.set_color(0,dragon_gradient.gradient.sample(_c))
	_gt.set_gradient(_g)
	greeble_multimesh.material_override.set_shader_parameter("gradient",_gt)
#	greeble_multimesh.multimesh = dragon_gradient.sample(.2)
	greeble_multimesh.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	greeble_multimesh.multimesh.instance_count = 30*scale_x
	greeble_multimesh.multimesh.visible_instance_count = 30*scale_x

	var rng = RandomNumberGenerator.new()
	var _t : Transform3D
	for i in greeble_multimesh.multimesh.visible_instance_count:
		_t = Transform3D()
		var _r = rng.randf()*(2*PI)
		_t.basis = _t.basis.rotated(Vector3(0.0,0.0,1.0),_r )
		_t = _t.translated(Vector3(cos(_r)*scale_x,sin(_r)*scale_y-scale_y*.6,rng.randf_range(-.5,.5)))
		greeble_multimesh.multimesh.set_instance_transform(i,_t )
#
#
#	place_element(wing, _s)
#
#func place_element(_e,_s):
#	_e.position.y=-_s.y


func _on_PickArea_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int):
#	if event is InputEventMouseMotion :
#		if _normal.y>0 : 
#			wing.visible = true
#		if _normal.y<0 :
#			wing.visible = false
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				sound_fx.pitch_scale = 0.5 + bone_id/20.0
				sound_fx.playing = true
				ring.visible = !ring.visible
				greeble_multimesh.visible = !ring.visible
				leg_left.visible = !leg_left.visible
#				if ring.visible :
#					ring.transform = ring.transform.orthonormalized()
#					ring.transform = ring.transform.scaled(Vector3(s*.8,s*.8, 1.0))
#					var tween = get_tree().create_tween()
#					tween.tween_property(ring , "transform", ring.transform.scaled(Vector3(s,s, 1.0)),.4)
				
				if ring.visible and ring_to_add != null :
					for n in ring.get_children():
						ring.remove_child(n)
					ring.add_child(ring_to_add.instantiate())

				fx.amount = scale_x*30+5
				fx.transform = fx.transform.orthonormalized()	
				fx.transform.origin= Vector3.ZERO
				fx.transform.origin.y= -scale_x*.6
				fx.process_material.emission_ring_inner_radius = scale_x*1.5-.1
				fx.process_material.emission_ring_radius = scale_x*1.5
				fx.restart()

func _on_collison_body_mouse_entered():
	get_tree().call_group("dragon", "stop")
	pass


func _on_collison_body_mouse_exited():
	get_tree().call_group("dragon", "play")
	wing.visible = false
