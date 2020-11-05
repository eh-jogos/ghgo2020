# Write your doc string for this file here
class_name HookShot
extends Position2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

signal hooked_onto_target(target_global_position)

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var is_active: = true setget _set_is_active

onready var ray_cast: RayCast2D = $RayCast2D
onready var arrow: Node2D = $Arrow
onready var snap_detector: Area2D = $SnapDetector
onready var cooldown: Timer = $Cooldown

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _state_machine: StateMachine = $HookshotStateMachine

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func can_hook() -> bool:
	var has_target = snap_detector.has_target()
	var is_cooldown_ready = cooldown.is_stopped()
	return is_active and has_target and is_cooldown_ready


func get_aim_direction() -> Vector2:
	var direction: = get_local_mouse_position().normalized()
	return direction

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_is_active(value: bool) -> void:
	is_active = value
	visible = value
	_state_machine.set_physics_process(value)
	_state_machine.set_process_input(value)

### -----------------------------------------------------------------------------------------------
