extends Label3D

onready var collider := $"../../InteractionCollider"


func _ready():
	visible = false

func connectToDialog(caller: Object):
	caller.connect("DialogStart", self, "onDialogStart")
	caller.connect("DialogStop", self, "onDialogStop")

func disconnectToDialog(caller: Object):
	caller.disconnect("DialogStart", self, "onDialogStart")
	caller.disconnect("DialogStop", self, "onDialogStop")
	
func onDialogStart(starter: Object):
	if starter != collider:
		return
	visible = true

func onDialogStop(ender: Object):
	visible = false
