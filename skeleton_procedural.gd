extends Skeleton3D
var bones = 20

# Called when the node enters the scene tree for the first time.
#func _ready():
	
	
func make (_l : int = 20):
	clear_bones()
	add_bone('body_0')
	set_bone_pose_position(0,Vector3(0,0,0)  )
	for i in range(_l):
		add_bone('body_'+str(i+1))
		set_bone_parent(i+1,i)
		set_bone_pose_position(i+1,Vector3(0,0,2)  )
#		set_bone_pose_scale(i+1,Vector3(1,1,1)  )
		var _t : Transform3D = Transform3D()
		_t.origin =Vector3(0,0,-1.0)
		set_bone_rest(i+1,_t)
	get_child(0).skeleton = get_path()
	
	force_update_bone_child_transform(0)
