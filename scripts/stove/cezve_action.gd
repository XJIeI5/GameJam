extends Label3D

onready var collider := $"../../InteractionCollider"
onready var cezve := $".."

var canBeFilled: bool = true
var canBeVisible: bool = false

func _ready():
	visible = false
	cezve.connect("boilingStart", self, "onBoilingStart")
	cezve.connect("boilingStop", self, "onBoilingStop")

func connectToDialog(caller: Object):
	caller.connect("DialogStart", self, "onDialogStart")
	caller.connect("DialogStop", self, "onDialogStop")

func disconnectToDialog(caller: Object):
	caller.disconnect("DialogStart", self, "onDialogStart")
	caller.disconnect("DialogStop", self, "onDialogStop")
	
func onDialogStart(starter: Object):
	if starter != collider:
		return
	canBeVisible = true
	visible = canBeFilled and canBeVisible

func onDialogStop(ender: Object):
	canBeVisible = false
	visible = false

func onBoilingStart():
	canBeFilled = false
	visible = canBeFilled and canBeVisible

func onBoilingStop():
	canBeFilled = true
	visible = canBeFilled and canBeVisible
