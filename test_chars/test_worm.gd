extends Node2D

onready var BODYS = self.get_children()
onready var HEAD = self.get_child(0)

func _ready():
	print(BODYS)
	for body in BODYS:
		if body != HEAD:
			body.connect("destr_me", self, "remove_body")
	refresh_next_pointers()

func _process(delta):
	pass
	
func refresh_next_pointers():
	var i = 1
	while i < BODYS.size():
		BODYS[i].NEXT = BODYS[i - 1]
		i += 1

func remove_body(body):
	body = body[0]
	print("destroying " + body.name)
	
	BODYS.remove(BODYS.find(body))
	
	refresh_next_pointers()
