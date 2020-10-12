class_name ResourceHitBox
extends ObjectHitBox


export(String,
		"NOTHING",
		"WOOD",
		"WOOD_PLANKS",
		"STONE") var type




func initialize():
	set_active(true)
	.initialize()
	register_item()


func uninitialize():
	set_active(false)
	.uninitialize()
	unregister_item()



func die(sender: ObjectHitBox):
	unregister_item()
	.die(sender)



func register_item():
	pass#RingMap.register_resource(type, owner)


func unregister_item():
	pass#RingMap.unregister_resource(type, owner)
