extends MeshInstance

signal boilingStart
signal boilingStop
signal usedCoffee(delta, readiness)
signal boilingCoffee(newReadiness)

onready var target: Spatial = $Target
var onBoiling: bool = false

# NOTE: affects readiness
export var boilingSpeed: float = 1.0
export var maxCoffee: float = 100.0
const maxReadiness: float = 200.0

var remainingCoffee: float = 0.0
var readiness: float = 0.0

func _process(delta: float):
	if not onBoiling:
		return
	if remainingCoffee == 0:
		return
	readiness += min(boilingSpeed * delta, maxReadiness)
	emit_signal("boilingCoffee", readiness)

func pourCoffeeInto(cup: Coffee.Cup, coffeeDelta: float):
	if cup == null:
		return
	if onBoiling:
		return
	if remainingCoffee-coffeeDelta < 0:
		coffeeDelta = 0.0
	remainingCoffee -= coffeeDelta
	emit_signal("usedCoffee", coffeeDelta, readiness)

