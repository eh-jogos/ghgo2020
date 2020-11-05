# Manages Air movement, including jumping and landing.
# You can pass a msg to this state, every key is optional:
# {
#	velocity: Vector2, to preserve inertia from the previous state
#	impulse: float, to make the character jump
# }
extends State

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var acceleration_x: = 5000.0

onready var move: = get_parent()
onready var player: Player = owner as Player

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("jump") and jump_count < number_of_air_jumps:
#		jump_count += 1
#		_jump(move.jump_impulse)
	move.unhandled_input(event)


func physics_process(delta: float) -> void:
	move.physics_process(delta)
	
	# Landing
	if owner.is_on_floor():
		var target_state: = "Move/Idle" if move.get_move_direction().x == 0 else "Move/Run"
		_state_machine.transition_to(target_state)


func enter(msg: Dictionary = {}) -> void:
	move.enter(msg)
	
	move.acceleration.x = acceleration_x
	if "velocity" in msg:
		move.velocity = msg.velocity 
		move.max_speed.x = max(abs(msg.velocity.x), move.max_speed.x)
	if "impulse" in msg:
		_jump(msg.impulse)


func exit() -> void:
#	jump_count = 0
	move.acceleration = move.default_acceleration
	move.exit()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _jump(impulse):
	move.velocity.y = 0
	move.velocity += _calculate_jump_velocity(impulse)


# Returns a new velocity with a vertical impulse applied to it
func _calculate_jump_velocity(impulse: float = 0.0) -> Vector2:
	var move: State = get_parent()
	return move.calculate_velocity(
		move.velocity,
		Vector2(move.max_speed.x, impulse),
		Vector2(0.0, impulse),
		1.0,
		Vector2.UP
	)

### -----------------------------------------------------------------------------------------------
