extends Node2D

var draw_array = []

func draw(vec, color):
	draw_array.append([vec, color])
	
func _process(delta):
	draw_array = []
	update()
	
func _draw():
	for cont in draw_array:
		draw_line(Vector2(0,0), cont[0], cont[1]) 
	