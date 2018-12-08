extends Node2D

onready var PLAYER = get_tree().get_root().find_node("main_ship", true, false)
onready var PLAYER_POS = PLAYER.global_position

var groups = ["enemy", "neutral", "default", "friendly", "unknown", "resource"]

export(int, 4, 20) var links_count = 7

func radar():
	pass

func _draw():
	pass
	

func _process(delta):
	PLAYER_POS = get_parent().get_node("main_ship").global_position
	self.global_position = PLAYER_POS 
	
	update()