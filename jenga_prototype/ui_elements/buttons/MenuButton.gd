# Write your doc string for this file here
extends TextureButton

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var pause_menu_nodepath: Resource

#--- private variables - order: export > normal var > onready -------------------------------------

var _pause_menu: PauseMenu

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	_pause_menu = get_node_or_null(pause_menu_nodepath.value)
	set_as_toplevel(true)


func _toggled(button_pressed) -> void:
	if pause_menu_nodepath.value == null:
		push_error("Pause Menu nodepath is null")
		assert(false)
	
	if not _pause_menu:
		_pause_menu = get_node(pause_menu_nodepath.value)
	
	if button_pressed:
		_pause_menu.open_pause_menu()
	else:
		_pause_menu.close_pause_menu()

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
