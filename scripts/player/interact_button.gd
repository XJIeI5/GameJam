extends Label

onready var player = $"../../../.."

func _ready():
	hide()
	player.connect("CanInteractStart", self, "onCanInteractStart")
	player.connect("CanInteractStop", self, "onCanInteractStop")

func onCanInteractStart():
	show()

func onCanInteractStop():
	hide()
