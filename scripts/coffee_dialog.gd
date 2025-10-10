extends StaticBody

# TODO: get rid of code duplication (look_at.gd)

onready var camera: Camera = $"../Camera"
onready var machine: Spatial = owner

var onInteraction := false
var caller: Object

func InteractWith(caller: Object):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	caller.emit_signal("DialogStart", self)
	camera.make_current()
	
	yield(get_tree().create_timer(0.1), "timeout")
	setOnInteraction(caller)


func _process(_delta: float):
	if not onInteraction:
		return
	if Input.is_action_just_pressed("Interact"):
		self.caller.emit_signal("DialogStop")
		self.caller.camera.make_current()
		
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
