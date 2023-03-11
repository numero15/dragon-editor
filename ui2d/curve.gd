#https://godotengine.org/qa/32506/how-to-draw-a-curve-in-2d
#http://kidscancode.org/godot_recipes/3.x/physics/rigidbody_drag_drop/
extends Path2D
const point = preload("res://ui2d/curve_controller.tscn")
var held_object = null

func _ready():
	for c in curve.point_count :		
		var point_instance = point.instantiate()
		point_instance.position = curve.get_point_position(c)
		point_instance.connect("clicked", _on_pickable_clicked)
		self.add_child(point_instance)
	
	for c in curve.point_count :
		if c > 0 :
			get_child(c).prev_neighbor = get_child(c-1)
		if c < curve.point_count-1 :
			get_child(c).next_neighbor = get_child(c+1)


func _on_pickable_clicked(object):
	if !held_object:
		held_object = object
		held_object.pickup()
		
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop()
			held_object = null
			get_tree().call_group("dragon", "remesh")

func _process(_delta):
	if held_object == null :
		return
	for c in curve.point_count :
		curve.set_point_position(c,get_child(c).position)
	queue_redraw()

func _draw():
	unpate_curve()
	
func unpate_curve():
	var points = curve.get_baked_points()
	if points:
		draw_polyline(points, Color.RED, 2, true)
