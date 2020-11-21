# Write your doc string for this file here
tool
class_name ReadOnlyDebugLine
extends VBoxContainer

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var field_name: String = "" setget _set_field_name
export(String, FILE, "*.tres") var shared_variable_path: String = ""

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _label: Label = $Label
onready var _value_label: RichTextLabel = $Value
onready var _shared_variable: SharedVariable = load(shared_variable_path) as SharedVariable

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	_label.text = field_name
	if not Engine.editor_hint:
		update_value()
		_shared_variable.connect_to(self, "_on_shared_variable_updated")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func update_value() -> void:
	_value_label.set_value(_shared_variable.value)

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_field_name(value: String) -> void:
	field_name = value
	
	if is_inside_tree():
		_label.text = field_name


func _on_shared_variable_updated():
	if not Engine.editor_hint:
		update_value()

### -----------------------------------------------------------------------------------------------
