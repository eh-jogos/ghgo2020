# Array that can be saved in disk like a custom resource. Used as [Shared Variables] so that
# the data it holds can be accessed and modified from multiple parts of the code. Based on the idea
# of Unity's Scriptable Objects and Ryan Hipple's Unite Talk.
# @category: Shared Variables
tool
class_name ArrayVariable
extends SharedVariable

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

# Shared Variable value
export var value: Array = [] setget _set_value

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func is_class(p_class: String) -> bool:
	return p_class == "ArrayVariable" or .is_class(p_class)


func get_class() -> String:
	return "ArrayVariable"

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_value(p_value: Array) -> void:
	value = p_value
	ResourceSaver.save(resource_path, self)
	emit_signal("value_updated")

### -----------------------------------------------------------------------------------------------
