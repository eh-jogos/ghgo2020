# Write your doc string for this file here
extends Sprite

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const FULL_CIRCLE = 2*PI
const HALF_CIRCLE = PI

#--- public variables - order: export > normal var > onready --------------------------------------

var drunk_factor: float = 1.0
var drunk_offset_range: float = 60.0
var drunk_shake_loop_duration: float = 1
var drunk_rotate_loop_duration: float = 4

var new_global_position: Vector2 = Vector2.ZERO
var drunk_offset: = Vector2.ZERO

#--- private variables - order: export > normal var > onready -------------------------------------

var _movement_time_count: float = 0
var _rotation_time_count: float = 0

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	pass

func _physics_process(delta):
	if not get_parent().is_dragging:
		return
	
	var movement_sine = stepify(sin(_movement_time_count), 0.001)
	_movement_time_count += (1/drunk_shake_loop_duration * FULL_CIRCLE) * delta
	if _movement_time_count > FULL_CIRCLE:
		_movement_time_count -= FULL_CIRCLE
	
	_rotation_time_count += (1/drunk_rotate_loop_duration * FULL_CIRCLE) * delta
	if _rotation_time_count > FULL_CIRCLE:
		_rotation_time_count -= FULL_CIRCLE
	
	var new_position = Vector2(drunk_offset_range * movement_sine, 0)
	new_position = new_position.rotated(_rotation_time_count)
	global_position = get_global_mouse_position() + new_position

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------

