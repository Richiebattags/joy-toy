extends Resource
class_name Controller

var vendor_list: Dictionary = {
	"054c": {
		"0ce6": {
			"name": "Ps5 Controller",
			"icon": "res://controller_icons/controller_playstation5.png",
			"type": "PS5"
		},
		"09cc": {
			"name": "Ps4 Controller (v2)",
			"icon": "res://controller_icons/controller_playstation4.png",
			"type": "PS4"
		},
		"05c4": {
			"name": "Ps4 Controller (v1)",
			"icon": "res://controller_icons/controller_playstation4.png",
			"type": "PS4"
		},
		"0268": {
			"name": "Ps3 Controller",
			"icon": "res://controller_icons/controller_playstation3.png",
			"type": "PS3"
		},
	},
}

enum ControllerType {
	GENERIC,
	STEAM,
	XBOX360,
	XBOXONE,
	PS3,
	PS4,
	PS5
}

@export var controller_name: String
@export var controller_index: int
@export var vendor_id: String
@export var product_id: String
@export var controller_type: ControllerType
@export var controller_icon: Texture2D

func _init(_vendor_id: int = 0 , _product_id: int = 0, _index_id: int = 0) -> void:
	controller_index = _index_id
	vendor_id = hex(_vendor_id)
	product_id = hex(_product_id)
	set_controller_info()
	
	
	
func set_controller_info() -> void:
	if vendor_list.has(vendor_id):
		if vendor_list[vendor_id].has(product_id):
			controller_name = vendor_list[vendor_id][product_id]["name"]
			controller_icon = load(vendor_list[vendor_id][product_id]["icon"])
			controller_type = vendor_list[vendor_id][product_id]["type"] as ControllerType
		else:
			controller_name = "Unknown Controller"
			controller_icon = load("res://controller_icons/generic_joystick.png")
			controller_type = ControllerType.GENERIC
	else:
		controller_name = "Unknown Controller"
		controller_icon = load("res://controller_icons/generic_joystick.png")
		controller_type = ControllerType.GENERIC


func hex(value: int) -> String:
	return "%04x" % value
