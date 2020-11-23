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

func append(item) -> void:
	value.append(item)
	auto_save()


func get_dict(instance: Object = self) -> Dictionary:
	var dict = {}
	if instance.get_class() == "ArrayVariable":
		dict = inst2dict(instance)
		dict.value = []
		dict.value.resize(instance.value.size())
		for index in instance.value.size():
			if dict.value[index] is Resource:
				dict.value[index] = get_dict(instance.value[index])
			else:
				dict.value[index] = inst2dict(instance.value[index])
	else:
		dict = inst2dict(instance)
	
	return dict


func load_dict(array: Array) -> void:
	value.resize(array.size())
	for index in array.size():
		if array[index] is Dictionary \
				and array[index].has("@subpath") \
				and array[index].has("@path"):
			var instance = dict2inst(array[index])
			if instance.get_class() == "ArrayVariable":
				value[index] = instance
				instance.load_dict(instance.value)
			else:
				value[index] = instance
		else:
			value[index] = array[index]
	
	auto_save()


func auto_save() -> void:
	var error = ResourceSaver.save(resource_path, self)
	if error != OK:
		print("ERROR %s | %s"%[error, resource_path])
	emit_signal("value_updated")

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_value(p_value: Array) -> void:
	value = []
	value = p_value
	auto_save()

### -----------------------------------------------------------------------------------------------
