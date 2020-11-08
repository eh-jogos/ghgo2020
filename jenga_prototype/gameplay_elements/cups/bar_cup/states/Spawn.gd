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

func enter(msg: Dictionary = {}) -> void:
	_cup.is_active = false
	_cup.skin.spawn()
	yield(_cup.skin, "animation_finished")
	_cup.skin.drink()
	_cup.mouse_guide.increase_drunkness()
	yield(_cup.skin, "animation_finished")
	_cup.tween.follow_property(
			_cup.main_rigid_body, "global_position", _cup.main_rigid_body.global_position,
			_cup.mouse_guide, "global_position", 0.5, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	_cup.tween.start()
	yield(_cup.tween, "tween_all_completed")
	_state_machine.transition_to("Dragging")

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
