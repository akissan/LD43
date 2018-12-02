extends Node2D

onready var trgts = get_tree().get_nodes_in_group("targets")

var closest_target = null

#var default_font = preload("res://fonts/unifont.tres")

var DEFAULT_RADIUS = 1000

var CT = 'M' #T / M

export(PackedScene) var _bullet

var CD = 0.7
var CD_cur = 0
var time = 0

var ACC_DEF = 8
var acc_cur = 0
var acc_cur_modif = Vector2(0,0)
onready var noise = OpenSimplexNoise.new()
  
func _draw():
	
	
	draw_empty_circle(Vector2(0,0), Vector2(DEFAULT_RADIUS,0), Color.green, 2.0)
	for trgt in trgts:
		draw_line(Vector2(0,0), to_local(trgt.global_position), Color.darkgreen)
	if CT == 'T':
		var ct_pos = to_local(closest_target.global_position).clamped(DEFAULT_RADIUS) + acc_cur_modif * get_local_mouse_position().length() / 200
		draw_line(Vector2(0,0), ct_pos , Color.green)
	else:
		var mouse_pos = get_local_mouse_position() + acc_cur_modif * get_local_mouse_position().length() / 200
		draw_line(Vector2(0,0), mouse_pos.normalized()*DEFAULT_RADIUS, Color.yellowgreen)
		draw_line(Vector2(0,0), mouse_pos, Color.yellowgreen)
		draw_line(Vector2(0,0), mouse_pos.clamped(DEFAULT_RADIUS), Color.green)
		
func _ready():
	noise.set_seed(randf() * 1000)
	self.add_to_group("guns")
	print(trgts)
	for trgt in trgts:
		trgt.connect("destroyed", self, "trgt_destroyed")

func _process(delta):
	time += delta
	print(acc_cur_modif)
	
	acc_cur_modif = acc_cur * 2 * Vector2(noise.get_noise_2d(time * 7 - 0.3, time * 4), noise.get_noise_2d(time * 10, time * 2 + 0.3))
	
	trgts = get_tree().get_nodes_in_group("targets")
	
	closest_target = null
	
	for trgt in trgts:
		var trgt_pos = to_local(trgt.global_position)
		var dist = trgt_pos.length()
		if closest_target == null or dist < self.position.distance_to(to_local(closest_target.global_position)):
			closest_target = trgt
	
	if closest_target == null or to_local(closest_target.global_position).length() > DEFAULT_RADIUS: 
		look_at(get_global_mouse_position())
		CT = 'M'	
		if Input.is_action_pressed("ui_right") and CD_cur < 0.00001:
			CD_cur = CD
			shot(get_global_mouse_position())
		
	else:
		look_at(closest_target.global_position)
		CT = 'T'
		if CD_cur < 0.00001:
			CD_cur = CD
			shot(closest_target.global_position)
			
	update()


func shot(tg_pos):
	var new_bullet = _bullet.instance()
	get_tree().get_root().get_children()[0].get_node("bullet_layer").add_child(new_bullet)
	new_bullet.global_position = $shot_pos.global_position
	new_bullet.ipos = self.global_position
	new_bullet.vel = tg_pos - new_bullet.global_position
	new_bullet.rotation = new_bullet.get_angle_to(tg_pos)
	
func _physics_process(delta):
	CD_cur = max(CD_cur - delta, 0)

func trgt_destroyed(trgt):
	if closest_target == trgt:
		closest_target = null
		CT = 'M'
	trgts.remove(trgts.find(trgt))

func draw_empty_circle(circle_center, circle_radius, color , resolution):
	var draw_counter = 1
	var line_origin = Vector2()
	var line_end = Vector2()
	line_origin = circle_radius + circle_center

	while draw_counter <= 360:
		line_end = circle_radius.rotated(deg2rad(draw_counter)) + circle_center
		draw_line(line_origin, line_end, color)
		draw_counter += 1 / resolution
		line_origin = line_end

	line_end = circle_radius.rotated(deg2rad(360)) + circle_center
	draw_line(line_origin, line_end, color)
	
func set_acc(velk):
	acc_cur = ACC_DEF * velk
	