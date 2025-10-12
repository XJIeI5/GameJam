extends Node

enum IngredientType {
		Coffee,
		Water,
		Milk,
	}

enum CupSize {
	Small,
	Medium,
	Large,
}

class Ingredient extends Node:
	var type # WARNING: ONLY IngredientType EXPECTED
	
	# WARNING: ONLY IngredientType EXPECTED
	func _init(type):
		self.type = type

class Layer extends Node:
	var type # WARNING: ONLY IngredientType EXPECTED
	var percent: float
	var readiness: float
	
	func _init(type, percent: float, readiness: float):
		self.type = type
		self.percent = percent
		self.readiness = readiness

class Cup extends Node:
	var size # WARNING: ONLY CupSize EXPECTED
	var Layers: Array = [] # WARNING: ONLY []Layer EXPECTED
	
	# WARNING: ONLY CupSize EXPECTED
	func _init(size):
		self.size = size

