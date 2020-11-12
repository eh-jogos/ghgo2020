# Write your doc string for this file here
extends ProgressBar

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const MAX_HUE_VALUE = 359

#--- public variables - order: export > normal var > onready --------------------------------------

var altered_state_level: int = 0
var altered_state_factor: FloatVariable

#--- private variables - order: export > normal var > onready -------------------------------------

var foreground_stylebox: StyleBoxFlat = get_stylebox("fg")

onready var _resource_preloader: ResourcePreloader = $ResourcePreloader

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	altered_state_factor = _resource_preloader.get_resource("drunk_factor")
	value = altered_state_factor.value
	altered_state_factor.connect_to(self, "_on_altered_state_factor_value_updated")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_altered_state_factor_value_updated() -> void:
	var new_level = int(altered_state_factor.value)
	
	if altered_state_factor.value > max_value:
		value = altered_state_factor.value - new_level
	else:
		value = altered_state_factor.value
	
	if new_level > altered_state_level:
		altered_state_level = new_level
		var current_hue = foreground_stylebox.bg_color.h
		current_hue = current_hue + 0.1 if current_hue <= 0.9 else current_hue + 0.1 - 1
		foreground_stylebox.bg_color.h = current_hue
		add_stylebox_override("fg", foreground_stylebox)
		foreground_stylebox = get_stylebox("fg")

### -----------------------------------------------------------------------------------------------
