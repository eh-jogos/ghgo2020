# Write your doc string for this file here
tool
class_name LevelData
extends Resource

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export(float, 0.0, 1.0, 0.01) var target_height: float = 0.6 setget _set_target_height
export(float, 0.0, 1.0, 0.01) var camera_level: float = 0.0 setget _set_camera_level
export(int) var altered_bar_total: int = 5 setget _set_altered_bar_total
export(int) var altered_bar_increment: int = 1 setget _set_altered_bar_increment
export(int) var altered_bar_win_bonus: int = -1 setget _set_altered_bar_win_bonus
export(float) var cup_scale: float = 1.0 setget _set_cup_scale

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func auto_save() -> void:
	property_list_changed_notify()
	if resource_path != "":
		ResourceSaver.save(resource_path, self, ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)


func _set_target_height(p_value: float) -> void:
	target_height = p_value
	auto_save()


func _set_camera_level(p_value: float) -> void:
	camera_level = p_value
	auto_save()


func _set_altered_bar_total(p_value: int) -> void:
	altered_bar_total = p_value
	auto_save()


func _set_altered_bar_increment(p_value: int) -> void:
	altered_bar_increment = p_value
	auto_save()


func _set_altered_bar_win_bonus(p_value: int) -> void:
	altered_bar_win_bonus = min(p_value, 0)
	auto_save()


func _set_cup_scale(p_value: float) -> void:
	cup_scale = p_value
	auto_save()


### -----------------------------------------------------------------------------------------------
