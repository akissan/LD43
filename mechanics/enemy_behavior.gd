extends "res://mechanics/base_behavior.gd"


onready var pursuer = preload("res://mechanics/enemy_types/pursuer.gd").new()
onready var interceptor = preload("res://mechanics/enemy_types/interceptor.gd").new()
onready var scout = preload("res://mechanics/enemy_types/scout.gd").new()

export(float, 0.01, 0.99) var Reaction_time = 0.03
export(bool) var APPROACH_AFRER_UNAGRE = false 

var AGRE = false
export(float, 150, 3000) var AGRE_DIST = 650
var UNAGRE_ENABLED = false
export(float, 150, 3000) var UNAGRE_DIST = 900


var FORCED_PEACE = false
var forced_peace_time = 0

var APPROACH = true
export(float, 0, 6000) var APPROACH_SPEED = 4000
export(float, 300, 3000) var APPROACH_DIST = AGRE_DIST * 0.9

func CHECK_UNAGRE():
	if get_dist(TARGET) > UNAGRE_DIST:
		AGRE = false
		TARGET = null
		

func force_peace_check(delta):
	forced_peace_time = max(0, forced_peace_time - delta)
	if forced_peace_time > eps:
		FORCED_PEACE = false
	else:
		FORCED_PEACE = true
	return  FORCED_PEACE

func force_peace(debuff_time):
	forced_peace_time = debuff_time
	FORCED_PEACE = true
	

func approached_check():
	if get_dist(TARGET) <= APPROACH_DIST:
		APPROACH = false
	else:
		APPROACH = true

func approach_vel():
	return simple_0_to_A(min(get_dist(TARGET) - APPROACH_DIST, 0), APPROACH_SPEED, 0.5 / APPROACH_DIST)
