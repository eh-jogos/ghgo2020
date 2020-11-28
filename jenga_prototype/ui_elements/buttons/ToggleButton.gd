# Write your doc string for this file here
tool
extends TextureButton

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var text: String = "Button text" setget _set_text
export var text_color_hover: = Color("3a283e")
export var text_color_normal: = Color("3a283e")

export var margin_normal_left: = 28
export var margin_normal_right: = 0
export var margin_pressed_left: = 18
export var margin_pressed_right: = -14

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _content: HBoxContainer = $Content
onready var _label: Label = $Content/Label
onready var _check_button: CheckButton = $Content/MarginContainer/CheckButton

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	eh_Utility.connect_signal(self, "button_down", self, "_on_button_down")
	eh_Utility.connect_signal(self, "button_up", self, "_on_button_up")
	eh_Utility.connect_signal(self, "mouse_entered", self, "_on_mouse_entered")
	eh_Utility.connect_signal(self, "mouse_exited", self, "_on_mouse_exited")
	
	_reset_appearence()


func _toggled(button_pressed):
	if not is_inside_tree():
		yield(self, "ready")
	
	if button_pressed:
		_content.margin_left = margin_pressed_left
		_content.margin_right = margin_pressed_right
	else:
		_content.margin_left = margin_normal_left
		_content.margin_right = margin_normal_right

	_check_button.pressed = !button_pressed

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _reset_appearence() -> void:
	_label.add_color_override("font_color", text_color_normal)
	_content.margin_left = margin_normal_left
	_content.margin_right = margin_normal_right
	self.pressed = false


func _set_text(value: String) -> void:
	text = value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	_label.text = value


func _on_mouse_entered() -> void:
	_label.add_color_override("font_color", text_color_hover)


func _on_mouse_exited() -> void:
	_label.add_color_override("font_color", text_color_normal)

### -----------------------------------------------------------------------------------------------
