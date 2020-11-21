# Write your doc string for this file here
extends VBoxContainer

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

signal levels_reordered
signal level_updated(index)

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const BUTTON_TEXT = "Level %s"

#--- public variables - order: export > normal var > onready --------------------------------------

var level_data: LevelData setget _set_level_data
var index: int = -1 setget _set_index

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _level_button: Button = $Buttons/Button

onready var _target_height_field: SpinBox = $LevelData/TargetHeightSpinBox
onready var _camera_level_field: SpinBox = $LevelData/CameraLevelSpinBox
onready var _bar_total_field: SpinBox = $LevelData/BarTotalSpinBox
onready var _bar_increment_field: SpinBox = $LevelData/BarIncrementSpinBox
onready var _altered_increment_field: SpinBox = $LevelData/AlteredIncrementSpinBox
onready var _cup_scale_field: SpinBox = $LevelData/CupScaleSpinBox

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_level_data(value: LevelData) -> void:
	level_data = value
	
	_target_height_field.value = level_data.target_height
	_camera_level_field.value = level_data.camera_level
	_bar_total_field.value = level_data.altered_bar_total
	_bar_increment_field.value = level_data.altered_bar_increment
	_altered_increment_field.value = level_data.altered_state_increment
	_cup_scale_field.value = level_data.cup_scale


func _set_index(value: int) -> void:
	index = value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	_level_button.text = BUTTON_TEXT%[index]


func _on_Up_pressed():
	if index > 0:
		index -= 1
		get_parent().move_child(self, index)
		emit_signal("levels_reordered")


func _on_Down_pressed():
	var limit = get_parent().get_child_count() - 1
	if index < limit:
		index += 1
		get_parent().move_child(self, index)
		emit_signal("levels_reordered")


func _on_Delete_pressed():
	get_parent().remove_child(self)
	queue_free()
	emit_signal("levels_reordered")


func _on_TargetHeightSpinBox_value_changed(value):
	level_data.target_height = value
	emit_signal("level_updated", index)


func _on_CameraLevelSpinBox_value_changed(value):
	level_data.camera_level = value
	emit_signal("level_updated", index)


func _on_BarTotalSpinBox_value_changed(value):
	level_data.altered_bar_total = value
	emit_signal("level_updated", index)


func _on_BarIncrementSpinBox_value_changed(value):
	level_data.altered_bar_increment = value
	emit_signal("level_updated", index)


func _on_AlteredIncrementSpinBox_value_changed(value):
	level_data.altered_state_increment = value
	emit_signal("level_updated", index)


func _on_CupScaleSpinBox_value_changed(value):
	level_data.cup_scale = value
	emit_signal("level_updated", index)

### -----------------------------------------------------------------------------------------------
