extends Node


enum ItemType {
	Nothing,
	Cup,
}

var CarriedItem: Node
# WARNING: ONLY ItemType EXPECTED
var itemType = ItemType.Nothing

func TakeNewItem(item: Node):
	self.CarriedItem = item
	itemType = assignType(item)
	print("CARRYING %s typeof %s" % [item.to_string(), ItemType.keys()[itemType]])


# WARNING: RETURNS ItemType
func assignType(item: Node):
	if item is Coffee.Cup:
		return ItemType.Cup
	push_error("hand can't carry item from node %s" % item)
