extends Node


var CarriedItem: Node

func TakeNewItem(item: Node):
	self.CarriedItem = item
	print("CARRYING %s" % item.to_string())
