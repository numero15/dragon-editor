extends Node3D

@export var anim_y_curve : Curve
@export var anim_y_dampening_curve : Curve

@onready var h = $Body
@onready var body = $Body
@onready var rings = $Rings

var sin_pos : float = 0

func _process(delta):
	sin_pos -= delta
	body.animate(sin_pos)
	rings.animate(sin_pos)
