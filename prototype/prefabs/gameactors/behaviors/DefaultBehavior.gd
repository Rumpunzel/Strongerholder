extends ActorBehavior
class_name DefaultBehavior



func next_priority(inventory:Array):
	if inventory.empty():
		return CityLayout.OBJECTS.TREE
	else:
		return CityLayout.OBJECTS.STOCKPILE
