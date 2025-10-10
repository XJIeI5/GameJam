extends VBoxContainer

onready var machine = $".."
onready var machineCollider = $"../InteractionCollider"

var lastType # WARNING: ONLY Coffee.IngredientType EXPECTED

const ColorCoffee: Color = Color("4b3621")
const ColorWater: Color = Color("51c4db")
const ColorMilk: Color = Color("fdfff5")

# TODO: instead of the progress bars, add a normal UI for a cup of coffee

func _ready():
	self.visible = false
	yield(machine, "ready")
	machine.connect("addIngredient", self, "onIngredientAdd")
	machine.player.connect("DialogStart", self, "onDialogStart")
	machine.player.connect("DialogStop", self, "onDialogStop")

func onIngredientAdd(ingredient: Coffee.Ingredient, deltaPercent: float):
	if machine.cup == null:
		return
	if lastType == null or ingredient.type != lastType:
		lastType = ingredient.type
		self.add_child(initProgressBar(lastType))
		print(get_children().size())
	else:
		get_children().back().value += deltaPercent

# WARNING: ONLY Coffee.IngredientType EXPECTED
func initProgressBar(ingredientType) -> ProgressBar:
	var bar: ProgressBar = ProgressBar.new()
	bar.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	return bar

func onDialogStart(starter: Object):
	if starter != machineCollider:
		return
	self.visible = true
	
func onDialogStop():
	self.visible = false
