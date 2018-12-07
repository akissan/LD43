extends Node2D

onready var PLAYER = get_tree().get_root().find_node("main_ship", true, false)
onready var GUI = get_tree().get_root().find_node("GUI", true, false)
onready var PLAYER_CAMERA = get_tree().get_root().find_node("main_camera", true, false)

func _process(delta):
	#GUI.move(PLAYER.global_position)
	
	camera_control()

var CAMERA_MOUSE_WEIGHT = 0.2
var CAMERA_SPEED = 0.08
var CAMERA_MAX_DIST = 900
var CAMERA_POS = Vector2()

func camera_control():
	var mouse_pos = get_global_mouse_position()
	var hero_pos = PLAYER.global_position
	var cam_vec = (mouse_pos - hero_pos).clamped(CAMERA_MAX_DIST)
	PLAYER_CAMERA.global_position = CAMERA_POS + ((hero_pos + (cam_vec) * CAMERA_MOUSE_WEIGHT) - CAMERA_POS)*CAMERA_SPEED
	CAMERA_POS = PLAYER_CAMERA.global_position
