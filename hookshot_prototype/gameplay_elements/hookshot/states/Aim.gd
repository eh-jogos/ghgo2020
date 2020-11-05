# Write your doc string for this file here
extends State

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

onready var hookshot: HookShot = owner as HookShot

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hook") and hookshot.can_hook():
		_state_machine.transition_to("Aim/Fire")


func physics_process(delta: float) -> void:
	var cast: Vector2 = hookshot.get_aim_direction() * hookshot.ray_cast.cast_to.length()
	var angle: = cast.angle()
	hookshot.ray_cast.cast_to = cast
	hookshot.ray_cast.force_raycast_update()
	hookshot.arrow.rotation = angle
	hookshot.snap_detector.rotation = angle


func enter(msg: Dictionary = {}) -> void:
	pass


func exit() -> void:
	pass

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
