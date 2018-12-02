extends Node2D

var DEFAULT_HEALTH = 200.0
var cur_health = DEFAULT_HEALTH

var HP_to_enemy = 170.0

signal destroyed

export(PackedScene) var test_dia_window
var WIND_OPENED = false
var WIND = null

func _process(delta):
	if cur_health < HP_to_enemy:
		add_to_group("targets")
	$HP.text = str(is_in_group("targets"))
	$BAR.value = cur_health / DEFAULT_HEALTH * $BAR.max_value

func _ready():
	#add_to_group("targets") 
	#add_to_group("neutral")
	pass
	
func get_damage(damage):
	cur_health -= damage
	if cur_health < 0:
		emit_signal("destroyed", self)
		self.queue_free()

func get_bullet_collision(bullet):
	get_damage(bullet.dmg)

func _on_mouse_area_mouse_entered():
	if not WIND_OPENED:
		WIND = test_dia_window.instance()
		self.add_child(WIND)
		WIND_OPENED = true
		WIND.OWNER = self

func _on_mouse_area_mouse_exited():
	if WIND_OPENED:
		WIND_OPENED = false
		WIND.queue_free()
		WIND = null
		
		
func unset_enemy():
	remove_from_group("targets")
		
func set_enemy():
	add_to_group("targets")