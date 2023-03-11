extends Path3D
const point = preload("res://curve_point.tscn")
const shader = preload("res://shaderUI_vertical_curve.tres")
@export var horizontal : bool = false
@onready var mesh = $CSGPolygon3D

# Called when the node enters the scene tree for the first time.
func _ready():
	for _p in curve.point_count:
		var point_instance = point.instantiate()
		point_instance.point_id = _p
		point_instance.target = $DragZone/DragTarget.get_path()
		point_instance.curve = get_path()
		point_instance.horizontal = horizontal
		point_instance.transform.origin = curve.get_point_position(_p) 
		if !horizontal :
			point_instance.get_child(1).mesh.material = shader
		self.add_child(point_instance)

func _on_dragon_3_length_changed(_l):
	transform.origin.z = -_l/2.0 + 2.5

func _on_spring_arm_3d_camera_rot_x(_r):
	
	var material = mesh.material
	if horizontal :
		material.albedo_color.a = abs(_r)/45
	if !horizontal :
		material.albedo_color.a = abs((90-abs(_r))/45)
		
	if material.albedo_color.a > 1 :
		material.albedo_color.a = 1
			
	
	mesh.material = material
	
	
	if horizontal and _r < 0:
		visible = true
	elif  horizontal and _r > 0:
		visible = false
	if !horizontal and _r < 0:
		visible = false
	elif  !horizontal and _r > 0:
		visible = true
