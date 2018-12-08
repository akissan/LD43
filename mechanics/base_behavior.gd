extends KinematicBody2D


onready var TARGET = null
export(String, "enemy", "neutral", "default", "friendly", "unknown", "resource") var BASE_GROUP = "default"

onready var CUR_GROUP = BASE_GROUP

export(float, 1, 2000) var MAX_HP = 200 
export(int, 50, 600) var SPEED_DEFAULT = 370
export(float, 5, 355) var ROTATE_DEFAULT_DEGREE = 400

var rot_speed = deg2rad(ROTATE_DEFAULT_DEGREE)

var turn_slow_cur = 0.0
var turn_slow = 0.17
var turn_slow_acc = 0.08

var rot_slow_cur = 0.0
var rot_slow = 0.45
var rot_slow_acc = 0.15

var speed_acc = 0.08
var vec_acc = 0.08

var cur_speed = 0.0
var cur_vel = Vector2(0,0)
var cur_rotation = 0.0

##
var cur_vec = Vector2(0,0)

var des_speed = cur_speed
var des_vel = cur_vel

var eps = 0.00001

func _ready():
	self.add_to_group(BASE_GROUP)

func get_cur_speed(cs = cur_speed, ds = des_speed, sa = speed_acc):
	var cs_res = Vector2( lerp(cs.x, ds.x, sa.x) ,  lerp(cs.y, ds.y, sa.y))
	
	return cs_res #cs.linear_interpolate(ds, speed_acc)

func get_acc_vec():
	var acc_des_cur = Vector2(0,0)
	if Input.is_action_pressed("move_forward"):
		acc_des_cur += Vector2(1, 0)
	if Input.is_action_pressed("move_back"):
		acc_des_cur += Vector2(-1, 0)
	if Input.is_action_pressed("move_left"):
		acc_des_cur += Vector2(0, -1)
	if Input.is_action_pressed("move_right"):
		acc_des_cur += Vector2(0, 1)
	return acc_des_cur

func get_rot(rot_dir, rot_speed):
	return rot_dir * rot_speed

func player_movenment(delta):
	var acc = get_acc_vec()
	rot_slow_cur = lerp(rot_slow_cur, rot_slow * abs(acc.x), rot_slow_acc)
	var rot = get_rot( acc.y, rot_speed * (1 - rot_slow_cur)) * delta
	cur_rotation += rot	
	turn_slow_cur = lerp(turn_slow_cur, turn_slow * abs(acc.y), turn_slow_acc)
	des_speed = acc.x * SPEED_DEFAULT
	cur_speed = lerp(cur_speed, des_speed, speed_acc)  
	cur_vel = cur_vel.linear_interpolate(cur_speed * (1 - turn_slow_cur) * Vector2(1,0).rotated(cur_rotation), vec_acc)
	self.move_and_slide(cur_vel)


func get_closest_in_group(group_name):
	var list = get_tree().get_nodes_in_group(group_name)
	return get_closest(list)

func get_closest(list):      
	var targets = list
	var dist = 9999999
	var closest_target = null
	for target in targets:
		var d = get_dist(target)
		if closest_target == null or d < dist:
			closest_target = target
			dist = d
	return closest_target  
	
func get_dist_pos(target_pos):
	return to_local(target_pos).length()

func get_dist(target):
	return to_local(target.global_position).length()

#B = 1 -> 0.8*a if x = 4, B = 3 -> 0.8*a if x = 1.3, B = 10 -> 0.8*a if x = 0.4
func simple_0_to_A(x, A = 1, B = 1): 
	return A * (1 - 1 / (B * x + 1))
	
func get_behavior():
	return BASE_GROUP      