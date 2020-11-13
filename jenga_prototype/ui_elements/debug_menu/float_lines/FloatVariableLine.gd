# Write your doc string for this file here
class_name FloatVariableDebugLine
extends VBoxContainer

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var field_name: String = ""
export(String, FILE, "*.tres") var float_variable_path: String = ""

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _label: Label = $Label
onready var _spin_box: SpinBox = $SpinBox
onready var _float_variable: FloatVariable = load(float_variable_path) as FloatVariable

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	_label.text = field_name
	
	_spin_box.min_value = -INF
	_spin_box.max_value = INF
	_spin_box.step = 0.01
	_spin_box.value = _float_variable.value
	
	_float_variable.connect_to(self, "_on_float_variable_value_updated")
	eh_Utility.connect_signal(_spin_box, "value_changed", self, "_on_spin_box_value_changed")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_spin_box_value_changed(p_value: float) -> void:
	_float_variable.value = p_value


func _on_float_variable_value_updated() -> void:
	_spin_box.value = _float_variable.value

### -----------------------------------------------------------------------------------------------
