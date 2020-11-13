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
export var value: float = 0.0 setget _set_value

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

func _set_value(p_value: float) -> void:
	value = p_value
	emit_signal("value_updated")
	ResourceSaver.save(resource_path, self)

### -----------------------------------------------------------------------------------------------
