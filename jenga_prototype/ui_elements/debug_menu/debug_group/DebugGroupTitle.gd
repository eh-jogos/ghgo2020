# Write your doc string for this file here
extends PanelContainer

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

onready var collapsed_state_shared_variable: BoolVariable = BoolVariable.new()

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _title_button: Button = $Content/TitleButton

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	collapsed_state_shared_variable.value = _title_button.pressed
	eh_Utility.connect_signal(_title_button, "toggled", self, "_on_title_button_toggled")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_title_button_toggled(is_pressed: bool) -> void:
	collapsed_state_shared_variable.value = is_pressed

### -----------------------------------------------------------------------------------------------
