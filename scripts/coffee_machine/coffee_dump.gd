extends Node

signal addLayer(ingredientType, percent, readiness)
signal addIngredient(ingredientType, deltaPercent, readiness)

onready var newPlayerPos: Spatial = $NewPlayerPos
export var stovePath: NodePath
onready var stove := get_node(stovePath)

var storedCallerPos: Vector3
var cup: Coffee.Cup

func _ready():
	connect("addLayer", self, "onAddLayer")
	yield(stove, "ready")
	for cezvePath in stove.cezves:
		stove.get_node(cezvePath).connect("usedCoffee", self, "onUsedCoffee")

func connectToDialog(caller: Object):
	caller.connect("DialogStart", self, "movePlayerAway")
	caller.connect("DialogStop", self, "bringPlayerBack")

func disconnectToDialog(caller: Object):
	caller.disconnect("DialogStart", self, "movePlayerAway")
	caller.disconnect("DialogStop", self, "bringPlayerBack")

func onAddLayer(ingredient: Coffee.Ingredient, percent: float, readiness: float):
	addLayer(ingredient, percent, readiness)
	printDebug()

func onUsedCoffee(percentDelta: float, readiness: float):
	emit_signal("addIngredient", Coffee.Ingredient.new(Coffee.IngredientType.Coffee), percentDelta, readiness)

func addLayer(ingredient: Coffee.Ingredient, percent: float, readiness: float):
	# TODO: ADD SIGNAL when percent OVERFLOWS
	if (percent == 0) or (cup == null):
		return
	
	if cup.Layers.size() == 0:
		var newLayer := Coffee.Layer.new(ingredient.type, percent, readiness)
		cup.Layers.append(newLayer)
	elif cup.Layers.back().type == ingredient.type and cup.Layers.back().readiness == readiness:
		cup.Layers[cup.Layers.size()-1].percent += percent
	else:
		var newLayer := Coffee.Layer.new(ingredient.type, percent, readiness)
		cup.Layers.append(newLayer)

func printDebug():
	if cup == null:
		return
	print("LAYERS:")
	for layer in cup.Layers:
		print("\t%s:%s" % [layer.type, layer.percent])

func movePlayerAway(caller: Object):
	storedCallerPos = caller.global_translation
	caller.global_translation = newPlayerPos.global_translation

func bringPlayerBack(caller: Object):
	caller.global_translation = storedCallerPos
