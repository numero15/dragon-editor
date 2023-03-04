extends Node3D
@export var skeleton: NodePath
const bone_manager = preload("res://Dragon_3/bone_manager.tscn")
var play : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var _skel = get_node(skeleton)
	for _id in _skel.get_bone_count():
		var bone_manager_instance = bone_manager.instantiate()
		bone_manager_instance.skeleton = _skel.get_path()		
		bone_manager_instance.bone_id = _id
		bone_manager_instance.chain_length = _skel.get_bone_count()
		self.add_child(bone_manager_instance)
		
	self.get_child(0).dampening = 1
	self.get_child(5).is_oscillator = true
	
#	setup rings
	for i in get_child_count() :
		if i > 0 :
			get_child(i).prev_node = get_child(i-1)
		else :
			get_child(i).prev_node = get_child(i)
		if i<get_child_count()-1 :
			get_child(i).next_node = get_child(i+1)
		else :
			get_child(i).next_node = get_child(i)
			

	var modifiers : Array = []
	for module in get_children():
		if module.is_oscillator or module.dampening > 0 :
			modifiers.append(module)
	for module in get_children():
		module.check_modifiers(modifiers)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !play : return
	update(delta)
	
func update(delta):
	var _skel = get_node(skeleton)
	_skel.reset_bone_poses ()
	for _m in get_children():
		if _m.bone_id ==0 : continue
		_m.update(delta)
