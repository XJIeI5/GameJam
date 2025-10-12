extends StaticBody

export(Coffee.CupSize) var DispensedCupSize

func InteractWith(caller: Object):
	var newCup = Coffee.Cup.new(DispensedCupSize)
	Hand.TakeNewItem(newCup)

