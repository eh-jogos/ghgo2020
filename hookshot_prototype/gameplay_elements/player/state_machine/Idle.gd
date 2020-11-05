# Write your doc string for this file here
extends State

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

onready var move = get_parent()
onready var player: Player = owner as Player

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
	if owner.is_on_floor():
		var floor_node = player.floor_scanner.get_collider()
		if floor_node is CheckPoint:
			move.velocity.x = 0
			_state_machine.transition_to("Win")
		
		if move.get_move_direction().x != 0.0:
			_state_machine.transition_to("Move/Run")
			return
	else:
		_state_machine.transition_to("Move/Air")
		return
	
	if move.velocity.x != 0:
		move.velocity = calculate_friction(move.velocity, move.friction, delta)
		move.velocity = player.move_and_slide(move.velocity, player.FLOOR_NORMAL)


func enter(msg: Dictionary = {}) -> void:
	move.enter(msg)
	
	move.max_speed = move.default_max_speed


func exit() -> void:
	move.exit()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
