extends MarginContainer
@export var props : NodePath
@onready var rings = $TabContainer/BodyContainer/MarginContainer/ScrollContainer/MarginContainer/Rings

func _ready():
	for _b in rings.get_children() :
		_b.toggled.connect( get_node(props).setup_props.bind(_b.type, _b.parameter))
