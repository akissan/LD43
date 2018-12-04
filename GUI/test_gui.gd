extends Node2D

func _process(delta):
	$ship_gui.move($main_ship.global_position)
	camera_control()

var CAMERA_MOUSE_WEIGHT = 0.2
var CAMERA_SPEED = 0.08
var CAMERA_MAX_DIST = 900
var CAMERA_POS = Vector2()

func camera_control():
	var mouse_pos = get_global_mouse_position()
	var hero_pos = $main_ship.global_position
	var cam_vec = (mouse_pos - hero_pos).clamped(CAMERA_MAX_DIST)
	$main_camera.global_position = CAMERA_POS + ((hero_pos + (cam_vec) * CAMERA_MOUSE_WEIGHT) - CAMERA_POS)*CAMERA_SPEED
	CAMERA_POS = $main_camera.global_position
