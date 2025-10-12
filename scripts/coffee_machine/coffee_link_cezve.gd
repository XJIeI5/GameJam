extends Button

export var linkCezveIndex: int = 0 
export var fillingSpeed: float = 10.0

onready var collider := $"../InteractionCollider"
onready var machine := $".."
onready var remainingCoffeeUI: Label = $RemainingCoffee
onready var readinessUI: Label = $Readiness
onready var cezve: Node

var readiness: float
var storedMl: float

var onDialog: bool = false

func _ready():
	visible = false
	connect("button_down", self, "onButtonDown")
	connect("button_up", self, "onButtonUp")
	yield(machine, "ready")
	cezve = machine.stove.get_node(machine.stove.cezves[linkCezveIndex])

func _process(delta: float):
	if not onDialog:
		return
	setUI()
	if not pressed:
		return
	cezve.pourCoffeeInto(machine.cup, fillingSpeed * delta)
	storedMl += fillingSpeed * delta

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
	setUI()

func onDialogStop(ender: Object):
	onDialog = false
	visible = false

func setUI():
	remainingCoffeeUI.text = "%.0f ml" % cezve.remainingCoffee
	readinessUI.text = "%.0f%%" % cezve.readiness

func onButtonDown():
	readiness = cezve.readiness

func onButtonUp():
	machine.emit_signal("addLayer", Coffee.Ingredient.new(Coffee.IngredientType.Coffee), storedMl, readiness)
	storedMl = 0.0
	readiness = 0.0
