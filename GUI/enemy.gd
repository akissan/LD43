extends Node2D

onready var PLAYER = get_parent().get_node("main_ship")

export(PackedScene) var enemy

var ed = 0

func enemy_gen():
	var target_pos = PLAYER.global_position
	var _new_enemy = enemy.instance()
	_new_enemy.SPEED_DEFAULT = rand_range(250, 400)
	_new_enemy.ACC_WEIGHT = rand_range(0.2, 0.9)
	_new_enemy.behavior = _new_enemy.BEH_LIST[round(rand_range(0, _new_enemy.BEH_LIST.size() - 1))]
	_new_enemy.INTERCEPT_WEIGHT = rand_range(0.2, 0.8)
	_new_enemy.PURSUIT_WEIGHT = rand_range(0.4, 0.6)
	_new_enemy.PURSUIT_DIST = rand_range(240, 400)
	_new_enemy.SCOUT_DIST = rand_range(260, 430)
	_new_enemy.MIN_DIST = rand_range(110, 180)
	_new_enemy.MAX_DIST = rand_range(500, 1000)
	_new_enemy.ERROR_RAD = rand_range(20, 200)
	_new_enemy.AGRE_RAD = rand_range(400,800)
	_new_enemy.DAMAGE = rand_range(10,15 + ed * 1.2)
	_new_enemy.ATTACK_RAD = rand_range(100,200 + ed * 10.0)
	_new_enemy.global_position = target_pos +  Vector2(randf() - 0.5, randf() - 0.5).normalized() * rand_range(spawn_rad_min, spawn_rad_max)
	self.add_child(_new_enemy)
	
var spawn_rad_min = 1900
var spawn_rad_max = 5000

var spawn_time_min = 1.2
var spawn_time_max = 4.5	
var spawn_time_cur = 0.0

onready var enemys = get_tree().get_nodes_in_group("enemy")
onready var enemy_cur_count = enemys.size()
var enemy_max_count = 10 + ed * 2
var enemy_max_count_player = 6

func _process(delta):
	spawn_time_cur = max(0, spawn_time_cur - delta)
	if spawn_time_cur < 0.0000001 and enemy_cur_count < enemy_max_count:
		spawn_time_cur = rand_range(spawn_time_min, spawn_time_max)
		enemy_gen()
		enemy_cur_count = get_tree().get_nodes_in_group("enemy").size()
		

