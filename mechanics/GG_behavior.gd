extends "res://mechanics/base_behavior.gd"

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
