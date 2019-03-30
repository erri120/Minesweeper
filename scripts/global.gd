extends Node

var width = 10
var height = 10
var allow_flags = true

func change_sceen(scene):
	get_tree().change_scene("res://scenes/"+scene)