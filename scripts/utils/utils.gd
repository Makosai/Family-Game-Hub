class_name Utils

static func free_name(node: Node):
	node.set_name(node.name + " (deleted)")
	node.free()

static func queue_free_name(node: Node):
	node.set_name(node.name + " (deleted)")
	node.queue_free()
