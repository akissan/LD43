extends Node2D

var ref_count = 0
var targets = []
var cur_timer = 0
var max_timer = 0
var own = null
var dmg = 0

func _ready():
	set_physics_process(true)

export(PackedScene) var debuff

func _physics_process(delta):
	cur_timer = max(0, cur_timer - delta)
	if cur_timer == 0:
		if ref_count > 0:
			hit_another(targets, dmg)
		self.queue_free()

func init(rc, trgts, timer, damage, cur_own):
	ref_count = rc
	targets = trgts
	cur_timer = timer
	max_timer = timer
	dmg = damage
	own = cur_own
	
func hit_another(targets, dmg):
	targets.remove(own)
	var new_t = targets[round(rand_range(0, targets.size()))]		
	var new_debuff = debuff.instance()
	new_t.add_child(new_debuff)
	targets.append(own)
	new_debuff.init(ref_count - 1, targets, max_timer * 0.75, dmg, get_parent())
	