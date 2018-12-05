extends Control

export(PackedScene) var _button

var module_count = 3
var option_count = 3

var mod_preset = [
	Vector2(-80, 10),
	Vector2(0, 60),
	Vector2(80, 10)
]

var opt_preset = [[
	Vector2(-185, -10),
	Vector2((-185 -130) * 0.5, (-10 + 65) * 0.5),
	Vector2(-130, 65)
	], [
	Vector2(-55, 135),
	Vector2(0, 150),
	Vector2(55, 135)
	], [
	Vector2(185, -10),
	Vector2((185 + 130) * 0.5, (-10 + 65) * 0.5),
	Vector2(130, 65)
	]
]

var opened_modules = []
var opened_options = [[],[],[]]

var state_table = [null, null, null]

var q1 = 0
var q1_m = 20
var q2 = 0
var q2_m = 12
var q3 = 0
var q3_m = 60

func show_quests():
	var string_1 = "Get some resources... " + str(q1) + "/" + str(q1_m) + '\n' 
	var string_2 = "Defeat scavengers..." + str(q2) + "/" + str(q2_m) + '\n'
	var string_3 = "CRAFT A BIG GUN..." + str(q3) + "/" + str(q3_m) + '\n'
	TERMINAL.console(string_1 + string_2 + string_3)

onready var MAIN_SHIP = get_tree().get_root().find_node("main_ship")
onready var TERMINAL = get_tree().get_root().find_node("TERMINAL")

func refresh():
	for om in opened_modules:
		var i = opened_modules.find(om)
		om.set_state(get_state(i))
		var j = 0
		for oo in opened_options[i]:
			var _l = []
			if om.is_empty(): 	_l = oo.get_node('butt').empty_options
			else: 				_l = oo.get_node('butt').module_options
			oo.set_state(_l[j]) 
			j +=1
			
var COVER_FORCE = false

var MODULE_AREA_HOVERED = false

func find_tooltip():
	var res = ""
	for oo in opened_options:
		for oi in oo:
			if oi.TOOLTIP == true:
				
				res = oi.find_tooltip()
	if res == "":
		for oo in opened_modules:
			if oo.TOOLTIP == true:
				res = oo.find_tooltip()
	return res

func cover_test():
	var hovered = []
	var smth_hovered = false
	test_hover()
	var i = 0
	for om in opened_modules:
		if om.HOVERED:
			hovered.append(om)
			smth_hovered = true
			if opened_options[i] == []:
				
				show_options(om)
		else:
			var some_options_hovered = false
			for oo in opened_options[i]:
				if oo.HOVERED == true:
					hovered.append(oo)
					some_options_hovered = true
					smth_hovered = true
			if some_options_hovered == false and opened_options[i] != []:
				close_options(om)
		i += 1
	
	if not MODULE_AREA_HOVERED and not MODULE_AREA_HOVERED:
		close_modules()
		show_quests()
	

func test_hover():
	if get_local_mouse_position().length() < 230:
		if MODULE_AREA_HOVERED == false:
			show_modules()
		MODULE_AREA_HOVERED = true
	else:
		MODULE_AREA_HOVERED = false

func check_quests():
	if q1 > q1_m and q2 > q2_m and q3 > q3_m:
		TERMINAL.console("Wow... \nThx for playing dis game, huhuh.\nUr lucky in dis space:)\nHope ur enjooyed dis litl adventure")

func _process(delta):
	
	check_quests()
	
	$tooltip.text = find_tooltip()
	var PLAYER = get_parent().get_node("main_ship")
	var res = PLAYER.res
	var res_max = str(PLAYER.res_max)
	$res.text = str(res[0]) + '/' + res_max +'◰\n' + str(res[1]) + '/' + res_max +'▥\n' + str(res[2]) + '/' + res_max + '◩\n'
	cover_test()
	
	
	# 1 ◰, 1 ▥ and 1 ◩ to upg

func show_modules():
	if opened_modules == []:
		for i in range(module_count):
			var new_module = _button.instance()
			$modules.add_child(new_module)
			
			new_module.get_node('butt').connect("me_pressed", self, "button_pressed", [new_module])
			
			new_module.rect_position = mod_preset[i]
			new_module.set_state(get_state(i))
			opened_modules.append(new_module)
			

func recognize_action(button):
	var ret = []
	for om in opened_modules:
		if om == button:
			var index = opened_modules.find(om)
			if get_state(index) == "MODULE":
				var new_str = state_table[index].get_stats()
				
				TERMINAL.console(new_str)
				
				
	for _o in opened_options:
		for oo in _o:
			if oo == button:
				var mindex = opened_options.find(_o)
				var action = button.get_state()
				MAIN_SHIP.command(mindex, action)
				
				if action != "SCRAP":
					var new_str = state_table[mindex].get_stats()
					TERMINAL.console(new_str)
				#print("ITS OPTION OF MODULE ", str(opened_options.find(_o)), " WITH INDEX = ", str(_o.find(oo)))

func button_pressed(button):
	#print("button : " + str(button) + ' ' + str(button.name) + ' is pressed')
	recognize_action(button)
	
func get_state(index):
	if state_table[index] == null:
		return "EMPTY"
	else:
		return "MODULE"

func show_options(module):
	var i = opened_modules.find(module)
	for j in range(option_count):
		var new_option = _button.instance()
		$options.add_child(new_option)
		new_option.rect_position = opt_preset[i][j]
		
		var _l = []
		if module.is_empty(): 	_l = new_option.get_node('butt').empty_options
		else: 					_l = new_option.get_node('butt').module_options
		
		
		new_option.get_node('butt').connect("me_pressed", self, "button_pressed", [new_option])
		
		new_option.set_state(_l[j])
		
		opened_options[i].append(new_option)

func close_all_options():
	for _m in opened_modules:
		close_options(_m)

func close_options(module):
	for _o in opened_options[opened_modules.find(module)]:
		_o.queue_free()
	opened_options[opened_modules.find(module)] = []
	
func close_modules():
	for _m in opened_modules:
		close_options(_m)
		_m.queue_free()
	opened_modules = []

func _ready():
	pass
	
func move(pos):
	self.rect_global_position = pos
