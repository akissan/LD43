extends Control

func is_mod(): return $butt.is_mod()

func is_empty(): return $butt.is_empty()

func is_option(): return $butt.is_option()

func set_state(state): 
	$butt.set_state(state)

func get_state():
	return $butt.cur_state

var HOVERED = false
var TOOLTIP = false

func find_tooltip():
	return $butt.find_tooltip()
