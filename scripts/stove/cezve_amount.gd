extends Label3D

onready var collider := $"../../InteractionCollider"
onready var cezve := $".."
var onDialog: bool = false


func _ready():
	visible = false

func _process(delta):
	if not onDialog:
		return
	text = "%.0f ml" % cezve.remainingCoffee

func connectToDialog(caller: Object):
	caller.connect("DialogStart", self, "onDialogStart")
	caller.connect("DialogStop", self, "onDialogStop")

func disconnectToDialog(caller: Object):
	caller.disconnect("DialogStart", self, "onDialogStart")
	caller.disconnect("DialogStop", self, "onDialogStop")
	
func onDialogStart(starter: Object):
	if starter != collider:
		return
	onDialog = true
	visible = true

func onDialogStop(ender: Object):
	onDialog = false
	visible = false
