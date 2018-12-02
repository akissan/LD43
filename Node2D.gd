extends KinematicBody2D

var dmg = 3
var ms = 20
var ipos = Vector2(0,0)
var max_range_sqred = 3400 * 3400
var vel = Vector2(0,0)
var speed = 700

var obj



func _ready():
	set_physics_process(true)
	

func _process(delta):
	if (global_position - ipos).length_squared() > max_range_sqred:
		self.queue_free()
		
func _physics_process(delta):
	obj = move_and_collide(vel.normalized() * speed * delta)
	if obj!= null: 
		obj.collider.get_hit(self)
		#obj.get_bullet_collision(self)
		self.queue_free()
	#if obj != null:
	#	print(obj)