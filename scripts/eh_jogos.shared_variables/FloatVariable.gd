# Float that can be saved in disk like a custom resource. 
# Used as [Shared Variables] so that the data it holds can be accessed and modified from multiple 
# parts of the code. Based on the idea of Unity's Scriptable Objects and Ryan Hipple's Unite Talk.
# @category: Shared Variables
tool
class_name FloatVariable
extends SharedVariable

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

# Shared Variable value
export var should_reset_value: bool = false setget _set_should_reset_value
export var default_value: float = 0.0 setget _set_default_value
export var value: float = 0.0 setget _set_value

var is_first_run_in_session: bool = true

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func is_class(p_class: String) -> bool:
	return p_class == "FloatVariable" or .is_class(p_class)


func get_class() -> String:
	return "FloatVariable"

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_should_reset_value(value: bool) -> void:
	should_reset_value = value


func _set_default_value(value: float) -> void:
	default_value = value


func _set_value(p_value: float) -> void:
	if is_first_run_in_session:
		is_first_run_in_session = false
		if should_reset_value:
			p_value = default_value
	value = p_value
	emit_signal("value_updated")
	ResourceSaver.save(resource_path, self)

### -----------------------------------------------------------------------------------------------
