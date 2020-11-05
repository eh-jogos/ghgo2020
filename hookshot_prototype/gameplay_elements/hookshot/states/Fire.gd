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

func physics_process(delta: float) -> void:
	if not Input.is_action_pressed("hook"):
		hookshot.arrow.release_hook()
		_state_machine.transition_to("Aim")


func enter(msg: Dictionary = {}) -> void:
	var target: HookTarget = hookshot.snap_detector.target
	hookshot.arrow.hook_position = target.global_position
	target.hooked_from(hookshot.global_position)

	hookshot.emit_signal("hooked_onto_target", target.global_position)

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
