class_name ResourceHitBox
extends ObjectHitBox


export(String,
		"Nothing",
		"Wood",
		"WoodPlanks",
		"Stone") var type




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
	RingMap.register_resource(type, owner)


func unregister_item():
	RingMap.unregister_resource(type, owner)
