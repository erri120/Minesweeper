extends Button

export (int) var field_width = 10
export (int) var field_height = 10
export (bool) var allow_flags = true

func _ready():
	pass

func _pressed():
	global.width = field_width
	global.height = field_height
	global.allow_flags = allow_flags
	get_tree().change_scene("res://scenes/main.tscn")