extends Node

signal addLayer(ingredientType, percent)
signal addIngredient(ingredientType, deltaPercent)

export(NodePath) var playerPath
onready var player = get_node(playerPath)
onready var newPlayerPos: Spatial = $NewPlayerPos

var storedCallerPos: Vector3
var caller: Object

var cup: Coffee.Cup

func _ready():
	connect("addLayer", self, "onAddLayer")
	player.connect("DialogStart", self, "movePlayerAway")
	player.connect("DialogStop", self, "bringPlayerBack")


func onAddLayer(ingredient: Coffee.Ingredient, percent: float):
	addLayer(ingredient, percent)
	printDebug()

func addLayer(ingredient: Coffee.Ingredient, percent: float):
	# TODO: ADD SIGNAL when percent OVERFLOWS
	if (percent == 0) or (cup == null):
		return
	
	if cup.Layers.size() == 0:
		var newLayer := Coffee.Layer.new(ingredient.type, percent)
		cup.Layers.append(newLayer)
	elif cup.Layers.back().type == ingredient.type:
		cup.Layers[cup.Layers.size()-1].percent += percent
	else:
		var newLayer := Coffee.Layer.new(ingredient.type, percent)
		cup.Layers.append(newLayer)

func printDebug():
	if cup == null:
		return
	print("LAYERS:")
	for layer in cup.Layers:
		print("\t%s:%s" % [layer.type, layer.percent])

func movePlayerAway(caller: Object):
	storedCallerPos = caller.translation
	self.caller = caller
	caller.translation = newPlayerPos.translation
	print(caller.translation)

func bringPlayerBack():
	caller.translation = storedCallerPos
