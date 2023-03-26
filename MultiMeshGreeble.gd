extends MultiMeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func setup(_mesh, _number, _starting_color, _scale_x,_scale_y):
	multimesh = MultiMesh.new()
	multimesh.mesh = _mesh
	multimesh.resource_local_to_scene = true
#	définir la première couleur du dégradé
	material_override.resource_local_to_scene = true
	var _gt = material_override.get_shader_parameter("gradient")
	_gt.resource_local_to_scene = true
	_gt.gradient.resource_local_to_scene = true
	var _g : Gradient = material_override.get_shader_parameter("gradient").gradient.duplicate(true)
	_g.set_color(0,_starting_color)
	_gt.set_gradient(_g)
	material_override.set_shader_parameter("gradient",_gt)
#	greeble_multimesh.multimesh = dragon_gradient.sample(.2)
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = _number*_scale_x
	multimesh.visible_instance_count = _number*_scale_x
	
	var rng = RandomNumberGenerator.new()
	var _t : Transform3D
	for i in multimesh.visible_instance_count:
		_t = Transform3D()
		var _r = rng.randf()*(2*PI)
		_t.basis = _t.basis.rotated(Vector3(0.0,0.0,1.0),_r )
		_t = _t.translated(Vector3(cos(_r)*_scale_x,sin(_r)*_scale_y-_scale_y*.6,rng.randf_range(-.5,.5)))
		multimesh.set_instance_transform(i,_t )
