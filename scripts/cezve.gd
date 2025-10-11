extends Area

signal boilingStart
signal boilingStop

onready var target: Spatial = $"./Target"
onready var cezve: MeshInstance = $".."
var onBoiling: bool = false
var canBeFilled: bool = false

# NOTE: affects readiness
export var boilingSpeed: float = 1.0
export var maxCoffee: float = 100.0

var remainingCoffee: float = 0.0
var readiness: float = 0.0

func _ready():
	connect("mouse_entered", self, "onMouseEntered")
	connect("mouse_exited", self, "onMouseExited")

func _input_event(camera: Object, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int):
	if not camera.is_current():
		return
	
	var mouseClick = event as InputEventMouseButton
	if not (mouseClick and mouseClick.button_index == BUTTON_LEFT):
		return
	
	var t := cezve.global_translation
	cezve.global_translation = target.global_translation
	target.global_translation = t
	
	onBoiling = not onBoiling
	if onBoiling:
		emit_signal("boilingStart")
	else:
		emit_signal("boilingStop")

func _process(delta: float):
	handleFill()
	handleBoiling(delta)

func handleFill():
	if Input.is_action_just_pressed("Interact") and canBeFilled:
		remainingCoffee = maxCoffee

func handleBoiling(delta: float):
	if not onBoiling:
		return
	if remainingCoffee == 0:
		return
	readiness += boilingSpeed * delta


func onMouseEntered():
	canBeFilled = true

func onMouseExited():
	canBeFilled = false
