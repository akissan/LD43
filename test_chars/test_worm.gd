extends Node2D

onready var BODYS = self.get_children()
onready var HEAD = self.get_child(0)

#onready var _rotation = HEAD.rotation

func _ready():
	print(BODYS)
	
	for body in BODYS:
		if body != HEAD:
			body.connect("destr_me", self, "remove_body")
	
	pass # Replace with function body.

func _process(delta):
	
	var i = 1
	
	while i < BODYS.size():
		#if i != 0:
		BODYS[i].NEXT = BODYS[i - 1]
		i += 1
#	pass

func remove_body(body):
	body = body[0]
	print("destroying " + body.name)

	BODYS.remove(BODYS.find(body))
	
	#BODYS.erase(body)
	
	var i = 1
	while i < BODYS.size():
		#if i != 0:
		BODYS[i].NEXT = BODYS[i - 1]
		i += 1
#	
	
	#BODYS[i].NEXT =