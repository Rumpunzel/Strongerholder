extends ActorBehavior
class_name DefaultBehavior



func next_priority(inventory:Array):
	if inventory.empty():
		return CityLayout.TREE
	else:
		return CityLayout.STOCKPILE
