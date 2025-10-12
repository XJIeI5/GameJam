extends StaticBody


onready var camera: Camera = $"../Camera"
onready var stove: Spatial = $".."

var onInteraction := false
var caller: Object

func InteractWith(caller: Object):
	for cezvePath in stove.cezves:
		var cezve := stove.get_node(cezvePath as NodePath)
		cezve.get_node("CoffeeAmount").connectToDialog(caller)
		cezve.get_node("Readiness").connectToDialog(caller)
		cezve.get_node("FillAction").connectToDialog(caller)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	caller.emit_signal("DialogStart", self)
	camera.make_current()
	
	yield(get_tree().create_timer(0.1), "timeout")
	setOnInteraction(caller)


func _process(_delta: float):
	pass

func _unhandled_input(event: InputEvent):
	if not onInteraction:
		return
	if Input.is_action_just_pressed("Interact"):
		self.caller.emit_signal("DialogStop", self)
		self.caller.camera.make_current()

		for cezvePath in stove.cezves:
			var cezve := stove.get_node(cezvePath as NodePath)
			cezve.get_node("CoffeeAmount").disconnectToDialog(caller)
			cezve.get_node("Readiness").connectToDialog(caller)
			cezve.get_node("FillAction").connectToDialog(caller)

		setOffInteraction()
		get_viewport().set_input_as_handled()

func setOnInteraction(caller: Object):
	self.caller = caller
	onInteraction = true

func setOffInteraction():
	onInteraction = false
	self.caller = null
