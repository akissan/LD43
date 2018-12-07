extends KinematicBody2D

export(int, 100, 600) var SPEED_DEFAULT = 370
var SPEED_MIN = 10
var speed_cur = 0.0
export(float, 0, 10) var ACC_WEIGHT = 1.0 / (1.6)
var acc_des_cur = Vector2()
var vel_cur = Vector2()
var cur_move_angle = 0
var ROTATE_DEFAULT = deg2rad(110)

var des_speed = 0
var acc_cur = 0

var eps = 0.00001

onready var TARGET = null

func get_mas(delta, acc):
	speed_cur = lerp(speed_cur, SPEED_DEFAULT * acc.y, ACC_WEIGHT * delta)
	if speed_cur < SPEED_MIN:
		vel_cur = Vector2(0,0)
	else:
		vel_cur = Vector2(1, 0).rotated(cur_move_angle) * speed_cur
	return vel_cur

func get_rot(delta, acc_des_cur):
	return acc_des_cur.x * ROTATE_DEFAULT * delta

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
	               