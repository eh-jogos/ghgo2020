# Utility functions to calculate steering motion
# If you keep it all static, you can use it as a "Library", but if you need to use non static
# functions or variables, remove the class_name, extend Node and set it as an autoload
class_name Steering
extends Reference

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const DEFAULT_MASS: = 2.0
const DEFAULT_SLOW_RADIUS: = 200.0
const DEFAULT_MAX_SPEED: = 400.0

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

static func follow(
		velocity: Vector2,
		global_position: Vector2,
		target_position: Vector2,
		max_speed: = DEFAULT_MAX_SPEED,
		mass: = DEFAULT_MASS
	) -> Vector2:
	"""
	Calculates and returns a velocity steering towards target_position
	"""
	var desired_velocity: = (target_position - global_position).normalized() * max_speed
	var steering: = (desired_velocity - velocity) / mass
	
	var new_velocity: = velocity + steering
	
	return new_velocity


static func drunk_follow(
		velocity: Vector2,
		global_position: Vector2,
		target_position: Vector2,
		drunk_factor: float,
		max_speed: = DEFAULT_MAX_SPEED,
		mass: = DEFAULT_MASS
	) -> Vector2:
		var drunk_offset = rand_range(-1000.0 * drunk_factor, 1000.0 * drunk_factor)
		var new_target_position = target_position + (Vector2.ONE * drunk_offset)
		print("Target: %s | Drunk Target: %s"%[target_position, new_target_position])
		var new_velocity = follow(velocity, global_position, new_target_position, max_speed, mass)
		print(new_velocity)
		return new_velocity


static func arrive_to(
		velocity: Vector2,
		global_position: Vector2,
		target_position: Vector2,
		max_speed: = DEFAULT_MAX_SPEED,
		slow_radius = DEFAULT_SLOW_RADIUS,
		mass: = DEFAULT_MASS
	) -> Vector2:
	"""
	Calculates and returns a new velocity with the arrive steering behavior
	"""
	var to_target: = global_position.distance_to(target_position)
	var desired_velocity: = (target_position - global_position).normalized() * max_speed
	if to_target < slow_radius:
		desired_velocity *= (to_target/slow_radius) * 0.75 + 0.25
	
	var steering: = (desired_velocity - velocity) / mass
	
	var new_velocity: = velocity + steering
	
	return new_velocity

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
