# Write your doc string for this file here
extends Sprite

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const FULL_CIRCLE = 2*PI
const HALF_CIRCLE = PI

#--- public variables - order: export > normal var > onready --------------------------------------

export var texture_empty: Texture
export var texture_grab: Texture

var is_full: = false setget _set_is_full

var drunk_offset: = Vector2.ZERO
var drunk_offset_range: FloatVariable
var drunk_shake_loop_duration: FloatVariable
var drunk_rotate_loop_duration:FloatVariable

var altered_factor: FloatVariable
var altered_increment: FloatVariable

var scale_factor: FloatVariable

var new_global_position: Vector2 = Vector2.ZERO

#--- private variables - order: export > normal var > onready -------------------------------------

var _node_path_variable: NodePathVariable
var _movement_time_count: float = 0
var _rotation_time_count: float = 0

var _node_path_cursor: NodePathVariable
var _cursor: Sprite

var _node_path_camera: NodePathVariable
var _camera: Camera2D

onready var _resources: ResourcePreloader = $ResourcePreloader
onready var _tween: Tween = $Tween

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_setup_shared_variables()
	global_position = get_global_mouse_position()
	eh_Utility.connect_signal(Events,
			"altered_level_raised", self, "_on_Events_altered_level_raised")
	eh_Utility.connect_signal(Events,
			"altered_level_decreased", self, "_on_Events_altered_level_decreased")
	
	_set_is_full(is_full)


func _physics_process(delta):
	if drunk_rotate_loop_duration.value != 0:
		_rotation_time_count += (1/drunk_rotate_loop_duration.value * FULL_CIRCLE) * delta
		if _rotation_time_count > FULL_CIRCLE:
			_rotation_time_count -= FULL_CIRCLE
	
	if drunk_shake_loop_duration.value != 0:
		var movement_sine = stepify(sin(_movement_time_count), 0.001)
		_movement_time_count += (1/drunk_shake_loop_duration.value * FULL_CIRCLE) * delta
		if _movement_time_count > FULL_CIRCLE:
			_movement_time_count -= FULL_CIRCLE
		
		var new_position = Vector2.ZERO
		new_position = Vector2(
			altered_factor.value * drunk_offset_range.value * scale_factor.value * movement_sine, 0)
		new_position = new_position.rotated(_rotation_time_count)
		global_position = get_global_mouse_position() + new_position
	
	if _camera:
		scale = Vector2.ONE * scale_factor.value

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func increase_altered_factor() -> void:
	_tween.interpolate_property(altered_factor, "value", 
			altered_factor.value, 
			altered_factor.value + altered_increment.value, 
			0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	_tween.start()


func decrease_altered_factor() -> void:
	_tween.interpolate_property(altered_factor, "value", 
			altered_factor.value, 
			altered_factor.value - altered_increment.value, 
			0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	_tween.start()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_is_full(value: bool) -> void:
	is_full = value
	
	if is_full:
		texture = texture_grab
		if _cursor:
			_cursor.texture = texture_grab
	else:
		texture = texture_empty
		if _cursor:
			_cursor.texture = texture_empty


func _setup_shared_variables() -> void:
	drunk_offset_range = _resources.get_resource("altered_offset_unit")
	drunk_rotate_loop_duration = _resources.get_resource("altered_angular_loop_duration")
	drunk_shake_loop_duration = _resources.get_resource("altered_linear_loop_duration")
	
	altered_increment = _resources.get_resource("altered_increment")
	altered_factor = _resources.get_resource("altered_factor")
	
	scale_factor = _resources.get_resource("scale_factor")
	
	_node_path_variable = _resources.get_resource("main_mouse_guide")
	_node_path_variable.value = self.get_path()
	
	_node_path_cursor = _resources.get_resource("cursor")
	_cursor = get_node_or_null(_node_path_cursor.value)
	if not _cursor:
		_node_path_cursor.connect_to(self, "_on_node_path_cursor_value_updated")
	else:
		if is_full:
			_cursor.texture = texture_grab
		else:
			_cursor.texture = texture_empty
	
	_node_path_camera = _resources.get_resource("main_camera")
	_camera = get_node_or_null(_node_path_camera.value)
	if not _camera:
		_node_path_camera.connect_to(self, "_on_node_path_camera_value_updated")


func _on_Events_altered_level_raised() -> void:
	increase_altered_factor()


func _on_Events_altered_level_decreased() -> void:
	decrease_altered_factor()


func _on_node_path_camera_value_updated() -> void:
	_camera = get_node(_node_path_camera.value)


func _on_node_path_cursor_value_updated() -> void:
	_cursor = get_node(_node_path_cursor.value)
	if is_full:
		_cursor.texture = texture_grab
	else:
		_cursor.texture = texture_empty

### -----------------------------------------------------------------------------------------------

