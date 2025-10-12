extends StaticBody

# TODO: get rid of code duplication (look_at.gd)

onready var camera: Camera = $"../Camera"
onready var machine: Spatial = $".."
onready var cupUI: VBoxContainer = $"../Cup"
onready var cezveLink1UI := $"../Link1"
onready var cezveLink2UI := $"../Link2"

var onInteraction := false
var caller: Object

func InteractWith(caller: Object):
	cupUI.connectToDialog(caller)
	machine.connectToDialog(caller)
	cezveLink1UI.connectToDialog(caller)
	cezveLink2UI.connectToDialog(caller)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	caller.emit_signal("DialogStart", self)
	camera.make_current()
	
	yield(get_tree().create_timer(0.1), "timeout")
	setOnInteraction(caller)


func _process(_delta: float):
	if not onInteraction:
		return
	if Input.is_action_just_pressed("Interact"):
		self.caller.emit_signal("DialogStop", self)
		self.caller.camera.make_current()
		
		cupUI.disconnectToDialog(caller)
		machine.disconnectToDialog(caller)
		cezveLink1UI.disconnectToDialog(caller)
		cezveLink2UI.disconnectToDialog(caller)
		
		setOffInteraction()

func setOnInteraction(caller: Object):
	self.caller = caller
	onInteraction = true
	if Hand.CarriedItem is Coffee.Cup:
		machine.cup = Hand.CarriedItem as Coffee.Cup

func setOffInteraction():
	onInteraction = false
	self.caller = null
	machine.cup = null
