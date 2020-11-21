# Write your doc string for this file here
tool
class_name FloatRangeVariableDebugLine
extends VBoxContainer

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var field_name: String = "" setget _set_field_name
export(String, FILE, "*.tres") var float_variable_path: String = ""
export var min_value: float = 0
export var max_value: float = 1
export var step: float = 0.1

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _label: Label = $Label
onready var _spin_box: SpinBox = $SpinBox
onready var _float_variable: FloatVariable = load(float_variable_path)

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	_label.text = field_name
	
	if not Engine.editor_hint:
		_spin_box.min_value = min_value
		_spin_box.max_value = max_value
		_spin_box.step = step
		_spin_box.value = _float_variable.value
		
		_float_variable.connect_to(self, "_on_float_variable_value_updated")
		eh_Utility.connect_signal(_spin_box, "value_changed", self, "_on_spin_box_value_changed")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_field_name(value: String) -> void:
	field_name = value
	
	if is_inside_tree():
		_label.text = field_name


func _on_spin_box_value_changed(p_value: float) -> void:
	if not Engine.editor_hint:
		_float_variable.value = p_value


func _on_float_variable_value_updated() -> void:
	if not Engine.editor_hint:
		_spin_box.value = _float_variable.value

### -----------------------------------------------------------------------------------------------
