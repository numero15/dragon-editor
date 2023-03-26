extends MarginContainer
@export var props : NodePath
@export var movable_props : NodePath
@onready var rings = $"TabContainer/leg and wings/MarginContainer/ScrollContainer/MarginContainer/Rings"
@onready var legs =$"TabContainer/leg and wings/MarginContainer2/Legs"

func _ready():
	for _b in rings.get_children() :
		_b.toggled.connect( get_node(props).setup_props.bind(_b.type, _b.parameter))
	for _b in legs.get_children() :
#		_b.toggled.connect( get_node(props).setup_props.bind(_b.type, _b.parameter))
		_b.toggled.connect( get_node(movable_props).setup_props.bind(_b.type, _b.parameter))
