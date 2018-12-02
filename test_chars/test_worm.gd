extends Node2D

onready var BODYS = $modules.get_children()
onready var HEAD = $modules.get_child(0)

var CAMERA_MOUSE_WEIGHT = 0.6
var CAMERA_SPEED = 0.2
var CAMERA_MAX_DIST = 600
var CAMERA_POS = Vector2()

func _ready():
	print(BODYS)
	var z = HEAD.z_index
	print(BODYS)
	for body in BODYS:
		if body != HEAD:
			body.connect("destr_me", self, "remove_body")

			z -= 1
			body.z_index = z
	refresh_next_pointers()
	CAMERA_POS = HEAD.global_position

func _process(delta):
	camera_control()
	
func refresh_next_pointers():
	var i = 1
	while i < BODYS.size():
		BODYS[i].NEXT = BODYS[i - 1]
		i += 1

func remove_body(body):
	body = body[0]
	print("destroying " + body.name)
	BODYS.remove(BODYS.find(body))
	refresh_next_pointers()

func camera_control():
	var mouse_pos = get_global_mouse_position()
	var hero_pos = HEAD.global_position
	var cam_vec = (mouse_pos - hero_pos).clamped(CAMERA_MAX_DIST)
	$worm_camera.global_position = CAMERA_POS + ((hero_pos + (cam_vec) * CAMERA_MOUSE_WEIGHT) - CAMERA_POS)*CAMERA_SPEED
	CAMERA_POS = $worm_camera.global_position
