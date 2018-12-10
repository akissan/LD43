extends "res://mechanics/GG_behavior.gd"

onready var MOD_GEN = $module_generator
onready var GUI = get_tree().get_root().find_node("GUI", true, false)
onready var RADAR = get_tree().get_root().find_node("radar", true, false)


var TARGETS = []

var time_from_death = 0
var DEAD = false
var time_to_restart = 0.3


func _process(delta):
	
	RADAR.get_cur_radar_units()
	
	if DEAD:
		time_from_death += delta
		if time_from_death > time_to_restart:
			get_tree().reload_current_scene()
	player_movenment(delta)
	
	time_from_get_hit += delta
	regen()
	$skin.modulate = Color(1.0, cur_hp / MAX_HP , cur_hp / MAX_HP)
	

var time_from_get_hit = 3.0
var time_from_hit_min = 3.0

func regen():
	if time_from_get_hit > time_from_hit_min:
		var regen_value = time_from_get_hit - time_from_hit_min
		cur_hp = min(cur_hp + regen_value, MAX_HP)
		
		
var cur_hp = MAX_HP

signal death

func get_hit(dmg):
	cur_hp = cur_hp - dmg
	time_from_get_hit = 0
	if cur_hp < 0:
		DEAD = true
		#get_parent().get_node("main_ship/black_screen/black_screen_animator").play("death")
		
		
	#	emit_signal("death")

	
func generate_stat_equip(): 
	var start_power = 6
	module_table.append(MOD_GEN.get_war_module(6))
	module_table.append(MOD_GEN.get_buff_module(6))
	module_table.append(MOD_GEN.get_buff_module(6))
	
	$modules.add_child(module_table[0])
	$modules.add_child(module_table[1])
	$modules.add_child(module_table[2])
	
	MAX_HP += module_table[0].hp_prv
	MAX_HP += module_table[1].hp_prv
	MAX_HP += module_table[2].hp_prv
	
	res_max += module_table[0].cap_prv
	res_max += module_table[1].cap_prv
	res_max += module_table[2].cap_prv
	
	
	refresh_module_table_gui()

func set_target(target):
	TARGET = target

func command(mindex, action):
	var module = module_table[mindex]
	if action == "SCRAP":
		
		MAX_HP -= module.hp_prv
		res_max -= module_table[mindex].cap_prv
		
		add_res(MOD_GEN.scrap(module))
		$modules.remove_child(module_table[mindex])
		module_table[mindex] = null
		
		
	if action == "REWORK":
		
		MAX_HP -= module_table[mindex].hp_prv
		res_max -= module_table[mindex].cap_prv
		
		$modules.remove_child(module_table[mindex])
		module_table[mindex] = MOD_GEN.rework(module)
		$modules.add_child(module_table[mindex])
		
		MAX_HP += module_table[mindex].hp_prv
		res_max += module_table[mindex].cap_prv
		
		
	if action == "UPGRADE":
		if try_to_spend([1, 1, 1]):
			spend([1, 1, 1])
			
			MAX_HP -= module_table[mindex].hp_prv
			res_max -= module_table[mindex].cap_prv
		
			module_table[mindex] = MOD_GEN.upgrade(module)
			
			MAX_HP += module_table[mindex].hp_prv
			res_max += module_table[mindex].cap_prv
			
	if action == "CREATE_S":
		if try_to_spend([1, 1, 1]):
			spend([1, 1, 1])
			module_table[mindex] = MOD_GEN.get_module([1, 1, 1])
			$modules.add_child(module_table[mindex])
		
			MAX_HP += module_table[mindex].hp_prv
			res_max += module_table[mindex].cap_prv
		
	if action == "CREATE_M":
		if try_to_spend([round(res[0] * 0.5), round(res[1] * 0.5), round(res[2] * 0.5)]):
			spend([round(res[0] * 0.5), round(res[1] * 0.5), round(res[2] * 0.5)])
			module_table[mindex] = MOD_GEN.get_module([round(res[0] * 0.5), round(res[1] * 0.5), round(res[2] * 0.5)])
			$modules.add_child(module_table[mindex])
		
			MAX_HP += module_table[mindex].hp_prv
			res_max += module_table[mindex].cap_prv
		
	if action == "CREATE_B":
		if try_to_spend(res):
			spend(res)
			module_table[mindex] = MOD_GEN.get_module(res)
			$modules.add_child(module_table[mindex])
			
			MAX_HP += module_table[mindex].hp_prv
			res_max += module_table[mindex].cap_prv
	
	for i in range(res.size()):
		if res[i] > res_max:
			res[i] = res_max
	if cur_hp > MAX_HP:
		cur_hp = MAX_HP
	
	refresh_module_table_gui()

func _ready():
	generate_stat_equip()

var module_max_cnt = 3
var module_table = []

func refresh_module_table_gui():
	GUI.state_table = module_table
	GUI.refresh()
	
var res = [5 + randi() % 2, 5 + randi() % 2, 5 + randi() % 2]
var res_max = 9

func add_res(_res):
	for i in range(res.size()):
		get_parent().get_node("ship_gui").q1 += _res[i]
		res[i] = min(res_max, res[i] + _res[i])
	#get_parent().get_node("ship_gui").show_quests()

func try_to_spend(_res):
	var can_spend = true
	for i in range(res.size()):
		if res[i] - _res[i] < 0:
			can_spend = false
	return can_spend
	
func spend(_res):
	for i in range(res.size()):
		res[i] -= _res[i]



func _on_black_screen_animator_animation_finished(anim_name):
	if anim_name == "death": pass
	#	get_tree().reload_current_scene()
		
		#get_tree().reload_current_scene()