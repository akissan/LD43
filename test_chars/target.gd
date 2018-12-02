extends Node2D

var DEFAULT_HEALTH = 200.0
var cur_health = DEFAULT_HEALTH

signal destroyed

func _process(delta):
	$HP.text = str(cur_health)
	$BAR.value = cur_health / DEFAULT_HEALTH * $BAR.max_value

func _ready():
	add_to_group("targets") 
	
func get_damage(damage):
	cur_health -= damage
	if cur_health < 0:
		emit_signal("destroyed", self)
		self.queue_free()

func get_bullet_collision(bullet):
	get_damage(bullet.dmg)