extends Control

onready var PLAYER = get_tree().get_root().find_node("main_ship", true, false)

func _process(delta):
	self.rect_global_position = PLAYER.global_position
	print(rect_global_position)