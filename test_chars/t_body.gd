extends StaticBody2D

func get_hit(bullet):
	get_parent().get_bullet_collision(bullet)