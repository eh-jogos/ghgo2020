# Parent state that abstracts and handles basic movement
# Move-related children states can delegate movement to it, or use its utility functions
extends State

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var default_max_speed: = Vector2(500.0, 1500.0)
export var default_acceleration: = Vector2(100000, 3000.0)
export var default_friction: = Vector2(4000, 0)
export var jump_impulse: = 900.0

var friction: = default_friction
var acceleration: = default_acceleration
var max_speed: = default_max_speed
var velocity: = Vector2.ZERO

onready var player: Player = owner as Player

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

static func calculate_velocity(
		old_velocity: Vector2,
		max_speed: Vector2,
		acceleration: Vector2,
		delta: float,
		move_direction: Vector2
	) -> Vector2:
	var new_velocity: = old_velocity
	
	new_velocity += move_direction * acceleration * delta
	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed.y)
	
	return new_velocity


static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		1.0
	)


func unhandled_input(event: InputEvent) -> void:
#	if player.is_on_floor() and event.is_action_pressed("jump"):
#		_state_machine.transition_to("Move/Air", { impulse = jump_impulse })
	pass


func physics_process(delta: float) -> void:
	velocity = calculate_velocity(velocity, max_speed, acceleration, delta, get_move_direction())
	velocity = player.move_and_slide(velocity, player.FLOOR_NORMAL)


func enter(msg: Dictionary = {}) -> void:
#	player.hook.connect("hooked_onto_target", self, "_on_hook_hooked_onto_target")
	pass


func exit() -> void:
#	player.hook.disconnect("hooked_onto_target", self, "_on_hook_hooked_onto_target")
	pass

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_hook_hooked_onto_target(target_global_position: Vector2) -> void:
	var distance_to_target: Vector2 = target_global_position - player.global_position
	if player.is_on_floor() and distance_to_target.y > 0.0:
		return
	
	_state_machine.transition_to(
			"Hook", 
			{"target_global_position": target_global_position, "velocity": velocity}
	)

### -----------------------------------------------------------------------------------------------
