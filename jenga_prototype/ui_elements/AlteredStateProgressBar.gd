# Write your doc string for this file here
extends ProgressBar

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const CORNER_RADIUS = 20

#--- public variables - order: export > normal var > onready --------------------------------------

var altered_factor: int = 0
var altered_state_level: int = 0
var altered_state_factor: FloatVariable
var subdivision_max_value: IntVariable
var subdivision_increment_step: IntVariable

#--- private variables - order: export > normal var > onready -------------------------------------

var fg_stylebox: StyleBoxFlat

onready var _resource_preloader: ResourcePreloader = $ResourcePreloader
onready var _subdivisions: HBoxContainer = $Subdivisions
onready var _level_label: Label = $AlteredLevel
onready var _tween: Tween = $Tween

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	fg_stylebox = get_stylebox("fg") as StyleBoxFlat
	_setup_shared_variables()
	Events.connect("cup_drinked", self, "_on_Events_cup_drinked")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func get_subdivision_instance() -> ColorRect:
	return _resource_preloader.get_resource("Subdivision1").instance()


func popuplate_progress_bar() -> void:
	if max_value == subdivision_max_value.value:
		return
	
	value = int(value) % subdivision_max_value.value
	max_value = subdivision_max_value.value
	
	altered_factor = altered_state_level * max_value + value
	
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


func decrement_altered_progress(p_decrement) -> void:
	altered_factor = max(altered_factor + p_decrement, 0)
	var new_level = int(altered_factor / subdivision_max_value.value)
	if new_level < altered_state_level:
		altered_state_level -= 1
		_level_label.text = str(altered_state_level)
		Events.emit_signal("altered_level_decreased")
	
	var new_value: = 0.0
	if altered_factor > max_value:
		if altered_factor % int(max_value) == 0:
			new_value = max_value
		else:
			new_value = altered_factor - max_value * new_level
	else:
		new_value = altered_factor
	
	value = new_value

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _setup_shared_variables() -> void:
	altered_state_factor = _resource_preloader.get_resource("altered_factor")
	value = altered_state_factor.value
	
	subdivision_increment_step = _resource_preloader.get_resource("increment_step")
	
	subdivision_max_value = _resource_preloader.get_resource("max_value")
	popuplate_progress_bar()
	subdivision_max_value.connect_to(self, "_on_altered_state_max_value_updated")


func _on_Events_cup_drinked() -> void:
	altered_factor += subdivision_increment_step.value
	var new_level = int(altered_factor / subdivision_max_value.value)
	
	var new_value: = 0.0
	if altered_factor > max_value:
		if altered_factor % int(max_value) == 0:
			new_value = max_value
		else:
			new_value = altered_factor - max_value * new_level
	else:
		new_value = altered_factor
	
	if new_value < value:
		value = 0
	
	if new_value == max_value:
		fg_stylebox.corner_radius_top_right = CORNER_RADIUS
		fg_stylebox.corner_radius_bottom_right = CORNER_RADIUS
	else:
		fg_stylebox.corner_radius_top_right = 0
		fg_stylebox.corner_radius_bottom_right = 0
	
	_tween.interpolate_property(self, "value", value, new_value, 
			0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	_tween.start()
	
	if new_level > altered_state_level:
		altered_state_level = new_level
		_level_label.text = str(altered_state_level)
		Events.emit_signal("altered_level_raised")


func _on_altered_state_max_value_updated() -> void:
	popuplate_progress_bar()

### -----------------------------------------------------------------------------------------------
