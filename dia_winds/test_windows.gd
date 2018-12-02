extends Control

var OWNER = null

func _on_B1_pressed():
	if OWNER != null:
		OWNER.unset_enemy()


func _on_B2_pressed():
	if OWNER != null:
		OWNER.set_enemy()
