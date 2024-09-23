class_name TweenUtils

static func tween_position(_self: Node, node: Node, pos: Vector2, time = 0.25, trans = Tween.TRANS_SINE):
	var tween = _self.create_tween()
	tween.tween_property(node, "position", pos, time).set_trans(trans)

static func tween_modulate(_self: Node, node: Node, color: Color, time = 0.25, trans = Tween.TRANS_SINE):
	var tween = _self.create_tween()
	tween.tween_property(node, "modulate", color, time).set_trans(trans)

static func tween_modulate_a(_self: Node, node: Node, alpha: float, time = 0.25, trans = Tween.TRANS_SINE):
	var color: Color = node.modulate
	color.a = alpha
	tween_modulate(_self, node, color, time, trans)
