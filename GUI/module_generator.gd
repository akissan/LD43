extends Node2D

var module_options = [ "UPGRADE", "REWORK", "SCRAP" ]
var empty_options = [ "CREATE_S", "CREATE_M", "CREATE_B" ]

var chances = [ 0.75 , 0.7 , 0.4 ]

export(PackedScene) var _module 

func upgrade(module):
	if module.TYPE == "WEAPON":
		module.dmg += rand_range(2, 6)
		module.wpn_cd -= 0.003
		module.wpn_cd_red_prv += 0.001 
	
	var power = get_power(module.res)
	if power > get_parent().get_parent().get_node("ship_gui").q3:
		get_parent().get_parent().get_node("ship_gui").q3 = power
		get_parent().get_parent().get_node("ship_gui").show_quests()
	return module 
	
func rework(module):
	var power = get_power(module.res)
	
	if power > get_parent().get_parent().get_node("ship_gui").q3:
		get_parent().get_parent().get_node("ship_gui").q3 = power
		get_parent().get_parent().get_node("ship_gui").show_quests()
	
	var old_type = module.TYPE
	var type_chance = randf()
	
	var new_module = null
	
	if type_chance > chances[1]:
		var nl = ["WEAPON", "WEAPON_REF", "BUFF"]
		nl.erase(old_type)
		module.TYPE = nl[randi() % nl.size()]
		if module.TYPE == "WEAPON" or module.TYPE == "WEAPON_REF":
			new_module = get_war_module(power)
		else:
			new_module = get_buff_module(power)
	else:
		if module.TYPE == "WEAPON" or module.TYPE == "WEAPON_REF":
			new_module = get_war_module(power)
		else:
			new_module = get_buff_module(power)
	module.queue_free()
	return new_module
	
func scrap(module):
	var res = []
	for _r in module.res:
		res.append( randi() % (int(_r) + 3) )
	module.queue_free()
	return res

func get_module(res):
	var power = get_power(res)
	
	if power > get_parent().get_parent().get_node("ship_gui").q3:
		get_parent().get_parent().get_node("ship_gui").q3 = power
		get_parent().get_parent().get_node("ship_gui").show_quests()
		
	var rand = randf()
	var res_module = null
	if rand < chances[2]:
		res_module = get_war_module(power)
	else:
		res_module = get_buff_module(power)
	return res_module

func get_war_module(power):
	var new_module = _module.instance()
	
	var weap_type = "WEAPON"
	var weap_type_chance = randf()
	if weap_type_chance > chances[0]:
		weap_type = "WEAPON_REF"
	
	new_module.init(
		weap_type,
		1,
		int(power * 0.25 + 1),
		randi() % int(power * 0.25 + 1),
		1 - power * 0.0025,
		power * 2.0 + randi() % int(power * 0.25 + 1),
		power * 1.7 + randi() % int(power * 0.2 + 1),
		randi() % 5 + int(power * 0.3 + 2),
		rand_range(1.5 / sqrt(power + 3), 1.5 / sqrt(power + 1)),
		110 + (power * 0.5 + randi()%int(power * 0.7 + 1)) * 10,
		[ round(power / 3.0), round((power + 1) / 3.0), round(power / 3.0) ] 
	)
	return new_module

func get_buff_module(power):
	var new_module = _module.instance()
	
	new_module.init(
		"BUFF",
		power * 0.5 + randi() % int(power + 1),
		int(power * 0.4 + randi()%(power + 1)  + 1),
		randi() % int(power * 0.1 + 1),
		1 - power * rand_range(0.001, 0.002),
		0,
		0,
		0,
		0,
		0,
		[ round(power / 3.0), round((power + 1) / 3.0), round(power / 3.0) ] 
	)
	return new_module

func get_power(res):
	var power = 0
	for r in res:
		power += r
	return int(power)
	
	