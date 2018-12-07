tool

extends Node2D

var time = 0

func fract(x):
	return x - floor(x)

func _draw():
	var c = abs(fract(sin(time) * 0.5 + 0.5 ))
	draw_circle(Vector2(0.0, 0.0), 500.0, Color(0.0, 0.0, 0.0, 0.05))
	draw_line(Vector2(100, 100), Vector2(500, 500), Color(1.0 - c, c, c * 0.5 + 0.5, 1.0))
	draw_line(Vector2(100, 100), Vector2(500, 500), Color(1.0 - c, c, c * 0.5 + 0.5, 1.0), 2.0, true)
	
func _process(delta):
	time += delta
	update()