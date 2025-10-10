extends StaticBody

onready var machine := $"../.."
onready var cup := $"../../Control/Cup"

var pressed: bool = false
var storedPercent: float = 0.0
var lastPrecent: float = 0.0

export var fillingSpeed: float = 10.0
export (Coffee.IngredientType) var type

func _input_event(camera, event, position, normal, shape_idx):
	var mouse_click = event as InputEventMouseButton
	if not (mouse_click and mouse_click.button_index == 1):
		return
	pressed = not pressed
	if pressed:
		onJustClicked()
	else:
		onJustReleased()

func _process(delta):
	if pressed:
		storedPercent += fillingSpeed * delta
		machine.emit_signal("addIngredient", Coffee.Ingredient.new(type), storedPercent-lastPrecent)
		lastPrecent = storedPercent

func onJustClicked():
	pass

func onJustReleased():
	machine.emit_signal("addLayer", Coffee.Ingredient.new(type), storedPercent)
	storedPercent = 0.0
	lastPrecent = 0.0

