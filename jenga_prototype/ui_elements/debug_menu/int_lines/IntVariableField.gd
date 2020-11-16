# Write your doc string for this file here
extends VBoxContainer

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var field_name: String = ""
export(String, FILE, "*.tres") var int_variable_path: String = ""
export var step: int = 1 setget _set_step

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _label: Label = $Label
onready var _spin_box: SpinBox = $SpinBox
onready var _int_variable: IntVariable = load(int_variable_path) as IntVariable

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	_label.text = field_name
	
	_spin_box.min_value = -INF
	_spin_box.max_value = INF
	_spin_box.step = 0.01
	_spin_box.value = _int_variable.value
	
	_int_variable.connect_to(self, "_on_int_variable_value_updated")
	eh_Utility.connect_signal(_spin_box, "value_changed", self, "_on_spin_box_value_changed")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_step(value: int) -> void:
	_spin_box.step = value


func _on_spin_box_value_changed(p_value: int) -> void:
	_int_variable.value = p_value


func _on_int_variable_value_updated() -> void:
	_spin_box.value = _int_variable.value

### -----------------------------------------------------------------------------------------------
