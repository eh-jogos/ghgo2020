# Base SharedVariable type, should never be used directly, it just defines some commom interface 
# for all [Shared Variables].
# The intent of [Shared Variables] are so that the data it holds can be saved to disk as a resource
# and loaded, accessed and modified from multiple parts of the code. 
# Based on the idea of Unity's Scriptable Objects and Ryan Hipple's Unite Talk.
# @category: Shared Variables
class_name SharedVariable
extends Resource

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

# Signal emitted when the Variable's value is updated.
signal value_updated

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var should_reset_value: bool = false setget _set_should_reset_value

var is_first_run_in_session: bool = true

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func is_class(p_class: String) -> bool:
	return p_class == "SharedVariable" or .is_class(p_class)


func get_class() -> String:
	return "SharedVariable"

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func connect_to(object: Object, func_name: String) -> void:
	if not is_connected("value_updated", object, func_name):
		connect("value_updated", object, func_name)


func disconnect_from(object: Object, func_name: String) -> void:
	if is_connected("value_updated", object, func_name):
		disconnect("value_updated", object, func_name)

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_should_reset_value(value: bool) -> void:
	should_reset_value = value

### -----------------------------------------------------------------------------------------------
