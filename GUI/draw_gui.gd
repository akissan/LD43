extends Node2D

onready var enemies = get_tree().get_nodes_in_group("enemy")
onready var everything = get_tree().get_nodes_in_group("everything")

onready var PLAYER = get_tree().get_root().find_node("main_ship", true, false)
onready var PLAYER_POS = PLAYER.global_position

var groups = ["enemy", "unknown", "neutral", "resource", "everything"]

var cols = [Color.red, Color(0.5, 0.5, 0.5, 0.8), Color.greenyellow, Color.white]
var peak_cols = [Color.orangered, Color.white, Color.green, Color.white]
var lerp_time = 0.85

var cur_units = [] #unit 
var cur_times = [] #time
var cur_checked = []

export(int, 4, 20) var links_count = 7

var draw_rad = 40.0

func group_to_color(group):
	return cols[groups.find(group)]

func group_to_peak_color(group):
	return peak_cols[groups.find(group)]

func get_closest(list):
	var d = 999999
	var closest = null
	for el in list:
		if closest == null or to_local(el.global_position).length() < d:
			closest = el
			d = to_local(el.global_position).length()
	return closest

func state_changed(unit):
	if cur_units.has(unit):
		var i = cur_units.find(unit)
		cur_times[i] = lerp_time

func radar():
	var radar_units = []
	PLAYER.TARGETS = radar_units
	everything = get_tree().get_nodes_in_group("everything")
	for i in range(links_count):
		if radar_units.size() < links_count and everything != []:
			var closest = get_closest(everything)
			radar_units.append(closest)
			everything.erase(closest)
	return radar_units
	
func draw_vec(tar_pos, col):
	var tp = to_local(tar_pos)
	var or_angle = tp.angle()
	var l_1 = tp.normalized() * draw_rad
	var l_2 = tp - l_1
	
	if (abs(or_angle - (l_2 - l_1).angle()) < 0.01):
		#var col = group_to_color(group)
		draw_line(l_1, l_2, col)

func get_color(unit):
	var col = Color.white
	if cur_units.has(unit):
		cur_checked[cur_units.find(unit)] = true
		col = group_to_color(unit.get_behavior())
		var k = cur_times[cur_units.find(unit)] / lerp_time 
		col += group_to_peak_color(unit.get_behavior()) * k * k * k 
	else:
		cur_units.append(unit)
		cur_times.append(lerp_time)
	return col
	
func _draw():
	cur_checked = []
	for i in range(cur_units.size()).size():
		cur_checked.append(false)
	
	var radar_units = radar()
	for unit in radar_units:
		var col = get_color(unit)
		draw_vec(unit.global_position, col)
	
	for i in range(cur_checked.size()):
		if cur_checked[i] == false:
				cur_times.remove(i)
				cur_units.remove(i)
	

func _process(delta):
	
	#print(cur_times)
	
	PLAYER_POS = get_parent().get_node("main_ship").global_position
	self.global_position = PLAYER_POS
	
	for i in range(cur_times.size()):
		cur_times[i] = max(0, cur_times[i] - delta)
		
	update()