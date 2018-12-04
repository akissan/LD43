extends Sprite

func _process(delta):
	self.rotation = get_parent().des_pos.angle() + PI * 0.5