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

onready var _label: Label = $Label

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	eh_Utility.connect_signal(self, "button_down", self, "_on_button_down")
	eh_Utility.connect_signal(self, "button_up", self, "_on_button_up")
	eh_Utility.connect_signal(self, "mouse_entered", self, "_on_mouse_entered")
	eh_Utility.connect_signal(self, "mouse_exited", self, "_on_mouse_exited")
	
	_reset_appearence()

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _reset_appearence() -> void:
	_label.add_color_override("font_color", text_color_normal)
	_label.margin_left = margin_normal_left
	_label.margin_right = margin_normal_right


func _set_text(value: String) -> void:
	text = value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	_label.text = value


func _on_button_down() -> void:
	_label.margin_left = margin_pressed_left
	_label.margin_right = margin_pressed_right


func _on_button_up() -> void:
	_label.margin_left = margin_normal_left
	_label.margin_right = margin_normal_right


func _on_mouse_entered() -> void:
	_label.add_color_override("font_color", text_color_hover)


func _on_mouse_exited() -> void:
	_label.add_color_override("font_color", text_color_normal)

### -----------------------------------------------------------------------------------------------
