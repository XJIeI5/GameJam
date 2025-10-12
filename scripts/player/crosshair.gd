extends TextureRect

onready var player = $"../../.."

func _ready():
	self.rect_position = get_viewport_rect().size/2 - self.rect_size/2
	player.connect("DialogStart", self, "onDialogStart")
	player.connect("DialogStop", self, "onDialogStop")
	
func onDialogStart(starter: Object):
	self.visible = false

func onDialogStop(ender: Object):
	self.visible = true
