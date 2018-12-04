extends "res://mechanics/simple_movenment.gd"

var BEH_LIST = ["Intercept", "Pursuit", "Scout"]

export(String, "Intercept", "Pursuit", "Scout") var behavior = "Intercept"

onready var PLAYER = get_parent().get_parent().get_node("main_ship")



export(float, 1, 1000) var HP_MAX = 200
var hp_cur = HP_MAX

var time = 0
var des_pos = Vector2()

export(float, 0, 3) var INTERCEPT_WEIGHT = 0.4
export(float, 0, 3) var PURSUIT_WEIGHT = 0.8
export(float, 0, 800) var PURSUIT_DIST = 150
export(float, 0, 800) var SCOUT_DIST = 200
export(float, 0, 400) var MIN_DIST = 60
export(float, 0, 800) var MAX_DIST = 400
export(float, 20, 200) var ERROR_RAD = 50
export(float, 100, 1000) var AGRE_RAD = 400

export(float, 10, 40) var DAMAGE = 12
export(float, 100, 300) var ATTACK_RAD = 420
export(float, 0.5, 1.3) var CD = 0.8

var cur_cd = 0

func attack():
	if cur_cd <= 0.0001 and to_local(PLAYER.global_position).length() < ATTACK_RAD:
		print("ATTACK")
		cur_cd = CD
		PLAYER.get_hit(DAMAGE * (0.9 + 0.2*randf()) ) 
		PLAYER.get_parent().get_node("draw_gui").state_changed(self) 



var MOUSE_RAD = 40

var MOUSE_HOVER = false

var AGRE = false
var FORCE_REVEAL = false

onready var time_seed = randf()

func check_mouse_enter():
	if get_local_mouse_position().length() < MOUSE_RAD:
		MOUSE_HOVER = true
		if Input.is_action_just_pressed("LMB"):
			if FORCE_REVEAL == false and AGRE == false:
				get_parent().get_parent().get_node("draw_gui").state_changed(self) 
			FORCE_REVEAL = true
			PLAYER.set_target(self)
	else:
		MOUSE_HOVER = false
		

func movenment_enemy(beh, delta, target_pos, target_vel):
	
	var agre_k = 1
	if not AGRE:
		agre_k = 0.002

	var noise_err = noise.get_noise_2d(time * time_seed, time * time_seed)
	var noise_vec = Vector2(cos(noise_err), sin(noise_err + noise_err)).normalized()
	
	if beh == "Intercept":
		des_pos = target_pos + target_vel * INTERCEPT_WEIGHT + ERROR_RAD * noise_vec + Vector2(1,0).rotated(noise_err) * PURSUIT_WEIGHT * target_vel.length()
	elif beh == "Pursuit":
		des_pos = target_pos - target_vel.normalized() * PURSUIT_DIST + target_vel * PURSUIT_WEIGHT + ERROR_RAD * (noise_vec).normalized()
	elif beh == "Scout":
		des_pos = target_pos + target_vel * INTERCEPT_WEIGHT + Vector2(1,0).rotated(time * 0.01) * SCOUT_DIST + ERROR_RAD * noise_vec + Vector2(1,0).rotated(SCOUT_DIST) * PURSUIT_WEIGHT
	des_pos = to_local(des_pos)

	self.move_and_slide(des_pos * inverse_lerp(MIN_DIST, MAX_DIST, to_local(target_pos).length()) * agre_k)
	
var target_pos = Vector2(0,0)
var target_vel = Vector2(0,0)

onready var noise = OpenSimplexNoise.new()

func get_hit(dmg):
	hp_cur -= dmg

func _process(delta):
	cur_cd = max(0, cur_cd - delta)
	attack()
	if hp_cur <= 0:
		PLAYER.TARGET = null
		PLAYER.add_res([randi() % 6, randi() % 6, randi() % 6])
		get_parent().ed += 1
		
		PLAYER.get_parent().get_node("ship_gui").q2 += 1
		PLAYER.get_parent().get_node("ship_gui").show_quests()
		
		self.queue_free()
		
	$hp_text.text = '[ ' + str(int(hp_cur / HP_MAX * 100)) + '% ]'
	time += 1
	target_pos = PLAYER.global_position
	
	target_vel = PLAYER.vel_cur
	
	if not AGRE:
		if to_local(target_pos + vel_cur).length() < AGRE_RAD:
			get_parent().get_parent().get_node("draw_gui").state_changed(self) 
			AGRE = true
			
	movenment_enemy(behavior, delta, target_pos, target_vel)
	check_mouse_enter()
	update()

var draw_rad = 70.0

func get_behavior():
	if AGRE or FORCE_REVEAL: 
		return "enemy"
	else:
		return "unknown"

func _draw():	
	pass