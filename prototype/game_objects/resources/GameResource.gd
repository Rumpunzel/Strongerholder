class_name GameResource, "res://assets/icons/icon_resource.svg"
extends GameObject


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
