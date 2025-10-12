extends Area

onready var cezve: MeshInstance = $".."
var mouseHovered: bool = false

func _ready():
	connect("mouse_entered", self, "onMouseEntered")
	connect("mouse_exited", self, "onMouseExited")
	connect("useCoffee", self, "reduceRemainingCoffee")

func _input_event(camera: Object, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int):
	if not camera.is_current():
		return
	
	var mouseClick = event as InputEventMouseButton
	if not (mouseClick and mouseClick.button_index == BUTTON_LEFT):
		return
	
	var t := cezve.global_translation
	cezve.global_translation = cezve.target.global_translation
	cezve.target.global_translation = t
	
	cezve.onBoiling = not cezve.onBoiling
	if cezve.onBoiling:
		cezve.emit_signal("boilingStart")
	else:
		cezve.emit_signal("boilingStop")

func _input(event: InputEvent):
	if Input.is_action_just_pressed("Interact") and mouseHovered:
		if not cezve.onBoiling:
			cezve.remainingCoffee = cezve.maxCoffee
			cezve.readiness = 0.0
		else:
			# TODO: add some kind of response to an action that couldn't be done
			pass
		get_viewport().set_input_as_handled()

func onMouseEntered():
	mouseHovered = true

func onMouseExited():
	mouseHovered = false
