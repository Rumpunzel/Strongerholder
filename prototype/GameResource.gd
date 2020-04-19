class_name GameResource, "res://assets/icons/icon_resource.svg"
extends KinematicBody


const REQUEST = "Request_"

const RESOURCES: Array = [
	"Wood",
	"WoodPlanks",
	"Stone",
]


export(String,
		"Nothing",
		"Wood",
		"WoodPlanks",
		"Stone") var type

export var weight:float


var called_dibs: bool = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
