extends Button

func _ready():
	pass
	
func _pressed():
	for i in get_tree().get_nodes_in_group("Buttons"):
		i.show()
	for j in get_tree().get_nodes_in_group("Menu"):
		j.hide()