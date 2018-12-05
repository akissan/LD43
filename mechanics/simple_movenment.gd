extends KinematicBody2D

export(int, 100, 600) var SPEED_DEFAULT = 370
var SPEED_MIN = 10
var speed_cur = 0.0
export(float, 0, 10) var ACC_WEIGHT = 1.0 / (1.6)
var acc_des_cur = Vector2()
var vel_cur = Vector2()
var cur_move_angle = 0
var ROTATE_DEFAULT = deg2rad(110)

func get_des_vel(a, b):
	return (b - a).normalized()

func get_mas(delta, acc):
	speed_cur = lerp(speed_cur, SPEED_DEFAULT * acc.y, ACC_WEIGHT * delta)
	if speed_cur < SPEED_MIN:
		vel_cur = Vector2(0,0)
	else:
		vel_cur = Vector2(1, 0).rotated(cur_move_angle) * speed_cur
	return vel_cur

func get_rot(delta, acc_des_cur):
	return acc_des_cur.x * ROTATE_DEFAULT * delta

func get_acc_vec():
	acc_des_cur = Vector2(0,0)
	if Input.is_action_pressed("move_forward"):
		acc_des_cur += Vector2(0, 1)
	if Input.is_action_pressed("move_back"):
		acc_des_cur += Vector2(0, -1)
	if Input.is_action_pressed("move_left"):
		acc_des_cur += Vector2(-1, 0)
	if Input.is_action_pressed("move_right"):
		acc_des_cur += Vector2(1,0)
	return acc_des_cur

func movenment_player(delta):
	acc_des_cur = get_acc_vec()
	cur_move_angle += get_rot(delta, acc_des_cur)
	
	self.rotate(cur_move_angle - rotation)
	self.move_and_slide(get_mas(delta, acc_des_cur))

func movenmnet_bot_to(delta, target):
	self.move_and_slide(get_mas(delta, get_des_vel(self.global_position, target)))
	
func get_closest(group_name):
	var targets = get_tree().get_nodes_in_group(group_name)
	var dist = 9999999
	var closest_target = null
	for target in targets:
		var d = to_local(target.global_position).length()
		if closest_target == null or d < dist:
			closest_target = target
			dist = d
	return closest_target
                                                                                      