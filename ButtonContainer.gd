extends HBoxContainer

var last_pressed : Button = null

func _ready() -> void:
	for button in get_children():
		button.toggled.connect(_on_Button_toggled.bind(button))

func _on_Button_toggled(is_pressed: bool, button: Button) -> void:
	if last_pressed == button:
		button.button_pressed = false
		last_pressed = null
	else:
		last_pressed = button
