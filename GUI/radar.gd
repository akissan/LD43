extends Node2D

onready var PLAYER = get_tree().get_root().find_node("main_ship", true, false)
onready var PLAYER_POS = PLAYER.global_position

var groups = ["enemy", "neutral", "default", "friendly", "unknown", "resource"]

export(Array, Color) var group_cols 

export(int, 4, 20) var links_count = 7

var cur_radar_units = []

export(float, 1, 90) var target_circle_rad = 48
export(float, 1, 90) var self_circle_rad = 40

func get_cur_radar_units():
	cur_radar_units = PLAYER.get_closest_c_from_group(links_count, "everything")
	cur_radar_units.erase(PLAYER)

func _draw():
	if PLAYER.TARGET != null:
		draw_empty_circle(to_local(PLAYER.TARGET.global_position), Vector2(target_circle_rad, 0), group_cols[groups.find("enemy")], 4)
	for unit in cur_radar_units:
		var _col = group_cols[ groups.find(unit.get_cur_behavior())]
		var dir_vec = to_local(unit.global_position)
		var a = dir_vec.normalized() * self_circle_rad
		var b = dir_vec - dir_vec.normalized() * target_circle_rad
		
		draw_line(a, b, _col)

func _process(delta):
	PLAYER_POS = get_parent().get_node("main_ship").global_position
	self.global_position = PLAYER_POS 
	update()

func draw_empty_circle(circle_center : Vector2 , circle_radius : Vector2, color : Color, resolution : int):
	var draw_counter = 1.0
	var line_origin = Vector2()
	var line_end = Vector2()
	line_origin = circle_radius + circle_center
	while draw_counter <= 360:
		line_end = circle_radius.rotated(deg2rad(draw_counter)) + circle_center
		draw_line(line_origin, line_end, color)
		draw_counter += 1.0 / resolution
		line_origin = line_end

	line_end = circle_radius.rotated(deg2rad(360)) + circle_center
	draw_line(line_origin, line_end, color)