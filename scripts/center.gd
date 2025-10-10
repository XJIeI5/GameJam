extends Control

export var offset: Vector2 = Vector2()

func _ready():
	self.rect_position = get_viewport_rect().size/2 - self.rect_size/2 + offset
