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
var altered_state_max_value: IntVariable

#--- private variables - order: export > normal var > onready -------------------------------------

var foreground_stylebox: StyleBoxFlat = get_stylebox("fg")

onready var _resource_preloader: ResourcePreloader = $ResourcePreloader
onready var _subdivisions: HBoxContainer = $Subdivisions

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	_setup_shared_variables()

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func get_subdivision_instance() -> ColorRect:
	return _resource_preloader.get_resource("Subdivision1").instance()


func popuplate_progress_bar() -> void:
	value = int(value) % altered_state_max_value.value
	max_value = altered_state_max_value.value
	
	for child in _subdivisions.get_children():
		_subdivisions.remove_child(child)
		child.queue_free()
	
	for index in max_value+1:
		var instance = get_subdivision_instance()
		_subdivisions.add_child(instance, true)
		if index == 0:
			var separation = (rect_size.x / max_value) - instance.rect_min_size.x
			_subdivisions.add_constant_override("separation", separation)
			instance.modulate.a = 0
		elif index == max_value:
			instance.modulate.a = 0

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _setup_shared_variables() -> void:
	altered_state_factor = _resource_preloader.get_resource("altered_factor")
	value = altered_state_factor.value
	altered_state_factor.connect_to(self, "_on_altered_state_factor_value_updated")
	
	altered_state_max_value = _resource_preloader.get_resource("max_value")
	popuplate_progress_bar()
	altered_state_max_value.connect_to(self, "_on_altered_state_max_value_updated")


func _on_altered_state_factor_value_updated() -> void:
	var altered_factor = altered_state_factor.value * 10
	var new_level = int(altered_factor / altered_state_max_value.value)
	
	if altered_factor > max_value:
		value = altered_factor - max_value * new_level
	else:
		value = altered_factor
	
	if new_level > altered_state_level:
		altered_state_level = new_level
		var current_hue = foreground_stylebox.bg_color.h
		current_hue = current_hue + 0.1 if current_hue <= 0.9 else current_hue + 0.1 - 1
		foreground_stylebox.bg_color.h = current_hue
		add_stylebox_override("fg", foreground_stylebox)
		foreground_stylebox = get_stylebox("fg")


func _on_altered_state_max_value_updated() -> void:
	popuplate_progress_bar()

### -----------------------------------------------------------------------------------------------
