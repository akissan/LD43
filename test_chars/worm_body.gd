extends KinematicBody2D

var NEXT = null

var ROTATE_RATE = 0.9 #deg2rad(110)
var cur_vel = Vector2(0,0)

var draw_vec = Vector2(0,0.01)

signal destr_me

func _ready():
	pass 
	
var correct_pos = Vector2(0,0)

func _draw():
	draw_line(Vector2(0,0), draw_vec.rotated(-rotation), Color.aqua)
	
	
func _process(delta):
	if NEXT != null:
		var Ipos = $APosI.global_position
		var Dpos = NEXT.get_node("APosO").global_position
		correct_pos = Dpos
		look_at(correct_pos)

		var cur_vel = NEXT.cur_vel
		
		var dst_vec = (Dpos - Ipos)
		if dst_vec.length() > 300:
			dst_vec = dst_vec.normalized() * 5
		if dst_vec.length() < 2:
			dst_vec = Vector2(0,0)
	
		draw_vec = NEXT.global_position - self.global_position
		update()
	
		self.move_and_slide(dst_vec * 30)
	

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed == true:
		emit_signal("destr_me", [self])
		queue_free()