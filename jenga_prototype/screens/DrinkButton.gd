# Write your doc string for this file here
extends Button

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const COLOR_NORMAL = Color("b3b3b3")
const COLOR_PRESSED = Color("c6e6ff")
const COLOR_HOVER = Color.white

#--- public variables - order: export > normal var > onready --------------------------------------

export var is_milkshake: bool = false
export var cup_type_shared_variable: Resource

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _panel =$VBoxContainer/Panel
onready var _label =$VBoxContainer/Label

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _pressed():
	cup_type_shared_variable.value = is_milkshake


func _process(_delta) -> void:
	if is_hovered():
		if pressed:
			modulate = COLOR_PRESSED
		else:
			modulate = COLOR_HOVER
		_panel.self_modulate.a = 1
		_label.self_modulate.a = 1
	else:
		modulate = COLOR_NORMAL
		_panel.self_modulate.a = 0.5
		_label.self_modulate.a = 0.5
	

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
