extends Node3D

func _on_dragon_3_length_changed(_l):
	transform.origin.z = -_l/2.0 + 2
