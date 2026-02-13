extends Control

@onready var connected_menu: Control = $BGPanel/VBoxContainer/AppContainer/MarginContainer/Connected
@onready var unconnected_menu: Control = $BGPanel/VBoxContainer/AppContainer/MarginContainer/Unconnected
@onready var control_dropdown: OptionButton = $BGPanel/VBoxContainer/AppContainer/MarginContainer/Connected/VBoxContainer/ControlDropdown
@onready var vibe_progress: TextureProgressBar = $BGPanel/VBoxContainer/AppContainer/MarginContainer/Connected/VBoxContainer/HBoxContainer/TextureProgressBar
@onready var timer: Timer = $Timer

var joypads: Array[Controller] = []
var vibe_strength: int = 0
var selected_joypad: int = 0

enum Pattern {
	SIN,
	SAW,
	ANAL
}
var pattern_playing: bool = false
var pattern: Pattern = Pattern.SIN
var time: float = 0
@export var speed: float = 1

func _ready() -> void:
	vibe_progress.value = vibe_strength
	Input.joy_connection_changed.connect(on_joy_connection_changed)
	menu_refresh()


func _process(delta: float) -> void:
	if pattern_playing:
		time += delta * speed
		if pattern == Pattern.SIN:
			var sine: float = 0.5 * sin(Time.get_ticks_msec() * 0.001) +0.5
			vibe_progress.value = sine * 100
			Input.start_joy_vibration(selected_joypad, sine, sine, 0)
		elif pattern == Pattern.SAW:
			var saw := fposmod(Time.get_ticks_msec() / 1000.0 * (speed/2.0), 1.0)
			vibe_progress.value = saw * 100
			Input.start_joy_vibration(selected_joypad, saw, saw, 0)	
#		elif pattern == Pattern.ANAL:
#			var anal := Time.get_ticks_msec() % 

	
func check_connected_joypads() -> bool:
	joypads.clear()
	var index_list: Array[int] = Input.get_connected_joypads()
	if index_list.size() != 0:
		for joy in index_list:
			var joy_info: Dictionary = Input.get_joy_info(joy)
			var controller: Controller = Controller.new(int(joy_info["vendor_id"]), int(joy_info["product_id"]), int(joy_info["xinput_index"]))
			joypads.append(controller)
		return true
	else:
		return false


func menu_refresh() -> void:
	if check_connected_joypads():
		connected_menu.visible = true
		unconnected_menu.visible = false
		create_dropdown_menu()
	else:
		connected_menu.visible = false
		unconnected_menu.visible = true


func reset_vibration() -> void:
	timer.stop()
	Input.stop_joy_vibration(selected_joypad)


func on_joy_connection_changed(_device_id: int, _connected: bool) -> void:
	menu_refresh()


func create_dropdown_menu() -> void:
	control_dropdown.clear()
	for joy in joypads:
		control_dropdown.add_item(joy.controller_name, joy.controller_index)
		control_dropdown.set_item_icon(joy.controller_index, joy.controller_icon)


func _on_vibe_up_button_up() -> void:
	if vibe_strength < 100:
		vibe_strength += 10
		vibe_progress.value = vibe_strength
		Input.start_joy_vibration(selected_joypad, float(vibe_strength)/100, float(vibe_strength)/100, 2)
		timer.start()


func _on_vibe_down_button_up() -> void:
	if vibe_strength > 0:
		vibe_strength -= 10
		vibe_progress.value = vibe_strength
		Input.start_joy_vibration(selected_joypad, float(vibe_strength)/100, float(vibe_strength)/100, 2)
		timer.start()


func _on_timer_timeout() -> void:
	Input.start_joy_vibration(selected_joypad, float(vibe_strength)/100, float(vibe_strength)/100, 2)


func _on_control_dropdown_item_selected(index: int) -> void:
	selected_joypad = index


func _on_close_button_button_up() -> void:
	pattern_playing = false
	reset_vibration()
	get_tree().quit()
	

func _on_sin_button_button_up() -> void:
	reset_vibration()
	if pattern_playing and pattern == Pattern.SIN:
		vibe_progress.value = 0
		pattern_playing = false
	else:
		pattern = Pattern.SIN
		pattern_playing = true


func _on_saw_button_button_up() -> void:
	reset_vibration()
	if pattern_playing and pattern == Pattern.SAW:
		vibe_progress.value = 0
		pattern_playing = false
	else:
		pattern = Pattern.SAW
		pattern_playing = true
