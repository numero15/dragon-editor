extends Path3D
const point = preload("res://curve_point.tscn")
@export var horizontal : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for _p in curve.point_count:
		var point_instance = point.instantiate()
		point_instance.point_id = _p
		point_instance.target = $DragZone/DragTarget.get_path()
		point_instance.curve = get_path()
		point_instance.horizontal = horizontal
		point_instance.transform.origin = curve.get_point_position(_p) 
		self.add_child(point_instance)

