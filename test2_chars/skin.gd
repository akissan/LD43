extends Sprite

func _process(delta):
	self.rotation = get_parent().cur_rotation + PI / 2.0