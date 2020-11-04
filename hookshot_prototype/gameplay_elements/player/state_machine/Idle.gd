# Write your doc string for this file here
extends State

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

onready var move = get_parent()

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

static func calculate_friction(
		old_velocity: Vector2,
		friction: Vector2,
		delta: float
	) -> Vector2:
	var new_velocity: = old_velocity
	
	if new_velocity.x >= 0:
		new_velocity -= friction * delta
		new_velocity.x = clamp(new_velocity.x, 0, new_velocity.x)
	else:
		new_velocity += friction * delta
		new_velocity.x = clamp(new_velocity.x, new_velocity.x, 0)
	
	return new_velocity


func unhandled_input(event: InputEvent) -> void:
	move.unhandled_input(event)


func physics_process(delta: float) -> void:
	if owner.is_on_floor() and move.get_move_direction().x != 0.0:
		_state_machine.transition_to("Move/Run")
		return
	elif not owner.is_on_floor():
		_state_machine.transition_to("Move/Air")
		return
	
	if move.velocity.x != 0:
		move.velocity = calculate_friction(move.velocity, move.friction, delta)
		move.velocity = owner.move_and_slide(move.velocity, owner.FLOOR_NORMAL)


func enter(msg: Dictionary = {}) -> void:
	move.enter(msg)
	
	move.max_speed = move.default_max_speed


func exit() -> void:
	move.exit()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
