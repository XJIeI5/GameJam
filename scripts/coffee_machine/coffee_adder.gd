extends StaticBody

onready var machine := $"../.."
onready var cup := $"../../Control/Cup"

var pressed: bool = false
var storedPercent: float = 0.0
var lastPrecent: float = 0.0

export var readiness: float = 100.0
export var fillingSpeed: float = 10.0
export (Coffee.IngredientType) var type

func _input_event(camera, event, position, normal, shape_idx):
	var mouse_click = event as InputEventMouseButton
	if not (mouse_click and mouse_click.button_index == BUTTON_LEFT):
		return
	pressed = not pressed
	if pressed:
		onJustClicked()
	else:
		onJustReleased()

func _process(delta):
	if not pressed:
		return
	storedPercent += fillingSpeed * delta
	machine.emit_signal("addIngredient", Coffee.Ingredient.new(type), storedPercent-lastPrecent, readiness)
	lastPrecent = storedPercent

func onJustClicked():
	pass

func onJustReleased():
	machine.emit_signal("addLayer", Coffee.Ingredient.new(type), storedPercent, readiness)
	storedPercent = 0.0
	lastPrecent = 0.0

