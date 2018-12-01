extends KinematicBody2D

var DEFAULT_SPEED = 400
var DEFAULT_ROTATE_SPEED = deg2rad(90)
var DEFAULT_ACC = 1/(0.7)

var cur_vel = Vector2(0,0)
var cur_acc = Vector2(0,0)
var cur_str_vel = 0

func _ready():
	pass

func _draw():
	draw_line(Vector2(0,0), Vector2(1,0) * cur_vel.length() , Color.orange)
	draw_line(Vector2(0,0), (cur_acc * Vector2(-1, 1)).rotated(-PI/2).normalized() * 200, Color.red)

func _process(delta):
	update()
	
	cur_acc = Vector2(0,0)
	if Input.is_action_pressed("move_forward"):
		cur_acc += Vector2(0, 1)
	if Input.is_action_pressed("move_back"):
		cur_acc += Vector2(0, -1)
	if Input.is_action_pressed("move_left"):
		cur_acc += Vector2(-1, 0)
	if Input.is_action_pressed("move_right"):
		cur_acc += Vector2(1,0)
	

	#if cur_acc.y == 0:
	#	cur_vel *= 0.9
	
	if cur_vel.length() < 1:
		cur_vel = Vector2(0,0)
		
	self.rotate(cur_acc.x * DEFAULT_ROTATE_SPEED * delta)
	
	cur_str_vel = lerp(cur_vel.length(), cur_acc.y * DEFAULT_SPEED, DEFAULT_ACC * delta)
	
	cur_vel = Vector2(1, 0).rotated(rotation).normalized() * cur_str_vel
	
	#cur_vel = self.move_and_slide(cur_vel)
	self.move_and_slide(cur_vel)
	
	
