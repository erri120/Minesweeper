extends Button

func _ready():
	pass

export (String) var scene = ""

func _pressed():
	global.change_sceen(scene)