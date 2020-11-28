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
	else:
		modulate = COLOR_NORMAL
	

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
