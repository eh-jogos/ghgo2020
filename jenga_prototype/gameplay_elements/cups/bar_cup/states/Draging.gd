# Write your doc string for this file here
extends State

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _cup: BaseCup = owner as BaseCup

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jenga_drop"):
		_state_machine.transition_to("Dropped")
		get_tree().set_input_as_handled()
	if event.is_action_pressed("jenga_rotate_clockwise"):
		_cup.main_rigid_body.rotation_degrees += 6
	elif event.is_action_pressed("jenga_rotate_anti_clockwise"):
		_cup.main_rigid_body.rotation_degrees -= 6


func physics_process(_delta: float) -> void:
	if _cup.mouse_guide:
		_cup.main_rigid_body.global_position = _cup.mouse_guide.global_position


func enter(msg: Dictionary = {}) -> void:
	_cup.set_collisons(false)

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
