extends Control


export(Texture) var icon

export(String, "WEAPON", "WEAPON_REF", "BUFF") var TYPE 

export(int, 0, 10) var hp_prv = 0
export(int, 0, 50) var cap_prv = 0
export(int, 0, 100) var add_dmg_prv = 0 
export(float, 0.0, 1.0) var wpn_cd_red_prv = 1.0

export(int, 0, 100) var dmg = 0
export(int, 0, 100) var dmg_ref = 0
export(int, 0, 20) var ref_cnt = 0
export(float, 0, 5.0) var wpn_cd = 0

export(float, 100, 1400) var wpn_rng = 200

var res = [0, 0, 0]

export(PackedScene) var ref_debuff

onready var cur_cd = wpn_cd
onready var DRAW 
onready var SHIP = get_parent().get_parent()

func init(_type, hpprv, capprv, adddmgprv, wpncdredprv, _dmg, dmgref, refcnt, wpncd, wpnrng, _res):
	TYPE = _type
	hp_prv = hpprv
	cap_prv = capprv
	add_dmg_prv = adddmgprv
	wpn_cd_red_prv = wpncdredprv
	dmg = _dmg
	dmg_ref = dmgref
	ref_cnt = refcnt
	wpn_cd = wpncd
	wpn_rng = wpnrng
	res = _res
	
#printfunc get_target():
	
func print_stats():
	print( 
		"\nTYPE: " + str(TYPE),
		"\nHP: " + str(hp_prv),
		"\nCAP: " + str(cap_prv),
		"\nDMG ADD: " + str(add_dmg_prv),
		"\nCD RED: " + str(wpn_cd_red_prv),
		"\nDMG: " + str(dmg),
		"\nDMG REF: " + str(dmg_ref),
		"\nREF CNT: " + str(ref_cnt),
		"\nWPN CD: " + str(wpn_cd),
		"\nWPN RNG: " + str(wpn_rng),
		"\nRES " + str(res), 
		'\n'
	)

func get_stats_for_weapon():
	var strings = [ 
		"TYPE : AUTOLOADING CANNON \nDAMAGE : " + str(dmg) + "\nRATE OF FIRE : " + str(round(60.0 / wpn_cd)) + "\nEFFECTIVE RANGE :" + str(wpn_rng),
		"TYPE : RIFLE CANNON \nDAMAGE : " + str(dmg) + "\nRATE OF FIRE : " + str(round(60.0 / wpn_cd)) + "\nEFFECTIVE RANGE :" + str(wpn_rng),
		"TYPE : FLAK GUN \nDAMAGE : " + str(dmg) + "\nRATE OF FIRE : " + str(round(60.0 / wpn_cd)) + "\nDAMAGE AMPLIFICATION :" + str(add_dmg_prv),
		"TYPE : MARKSMAN GAUSS RIFLE \nDAMAGE : " + str(dmg) + "\nRELOAD IMPROVMENT : " + str(wpn_cd_red_prv) + "\nRATE OF FIRE :" + str(round(60.0 / wpn_cd))
	]
	strings.shuffle()
	return strings[0]
	
func get_stats_for_weapon_ref():
	var strings = [ 
		"TYPE : MID-RANGED LASER CANNON \nDAMAGE : " + str(dmg_ref) + "\nRATE OF FIRE : " + str(round(60.0 / wpn_cd)) + "\nREFLECTION COUNT :" + str(ref_cnt),
		"TYPE : SWARM FLAK CANNON \nDAMAGE : " + str(dmg_ref) + "\nREFLECTION COUNT : " + str(ref_cnt) + "\nEFFECTIVE RANGE :" + str(wpn_rng),
		"TYPE : BEEP-BOOP GUN \nDAMAGE : " + str(dmg_ref) + "\nRATE OF FIRE : " + str(round(60.0 / wpn_cd)) + "\nDAMAGE AMPLIFICATION :" + str(add_dmg_prv),
		"TYPE : GREAT BEAM AUTORIFLE \nDAMAGE : " + str(dmg_ref) + "\nEFFECTIVE RANGE : " + str(wpn_rng) + "\nRELOAD IMPR-NT :" + str(wpn_cd_red_prv)
	]
	strings.shuffle()
	return strings[0]
	
func get_stats_for_buff():
	var strings = [ 
		"TYPE : OLD FRIDGE \nHP GAIN : " + str(hp_prv) + "\nCAPACITY : " + str(cap_prv) + "\nDMG ADD :" + str(add_dmg_prv),
		"TYPE : WORLD ACCELERATOR \nHP GAIN : " + str(hp_prv) + "\nRELOAD IMPR-NT : " + str(wpn_cd_red_prv) + "\nDNG HUHUHUH :" + str(add_dmg_prv),
		"TYPE : PHANTOM AMPLIFIER \nHP GAIN : " + str(hp_prv) + "\nDAMAGE AMPLIF : " + str(add_dmg_prv) + "\nCAPACITY :" + str(cap_prv),
		"TYPE : EFFORTS CONSTRICTOR \nHP GAIN : " + str(hp_prv) + "\nCAPACITY : " + str(cap_prv) + "\nRELOAD IMPROVMENT :" + str(wpn_cd_red_prv)
	]
	strings.shuffle()
	return strings[0]
	
func get_stats():
	if TYPE == "WEAPON":
		return get_stats_for_weapon()
	elif TYPE == "WEAPON_REF":
		return get_stats_for_weapon_ref()
	else:
		return get_stats_for_buff()
		

func _ready():
	set_physics_process(true)
	
func _physics_process(delta):
	cur_cd = max(0.0, cur_cd - delta)	
	#recalculate_buff()
	if TYPE == "WEAPON":
		if cur_cd < 0.00001: 
			var targ = get_target()
			#print(targ)
			if targ != null and (targ.global_position - SHIP.global_position).length() < wpn_rng:
				shot(SHIP.global_position, targ, wpn_cd_red_prv, add_dmg_prv)
				
				
	elif TYPE == "WEAPON_REF":
		if cur_cd < 0.00001: 
			var targ = get_target()
			var targets = SHIP.TARGETS
			if targ != null:
				shot(SHIP.global_position, targ, wpn_cd_red_prv, add_dmg_prv)
				#shot_ref(SHIP.global_position, targ, targets, wpn_cd_red_prv, add_dmg_prv)

func get_target():
	return SHIP.TARGET

func shot(owner_pos, target, wpn_cd_red, dmg_buff):
	cur_cd = wpn_cd * wpn_cd_red
	target.get_hit(dmg + dmg_buff)
	SHIP.get_parent().get_node("draw_gui").state_changed(target) 
	
func shot_ref(owner, target, targets, wpn_cd_red, dmg_buff):
	cur_cd = wpn_cd * wpn_cd_red
	target.get_hit(dmg + dmg_buff) 
	target.add_child(ref_debuff)
	SHIP.get_parent().get_node("draw_gui").state_changed(target) 





