# Write your doc string for this file here
extends State

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

onready var line: TargetLine = owner as TargetLine

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func enter(_msg: Dictionary = {}) -> void:
	line._animator.play("win")


# This is called at the end of "win" animation
func back_to_idle() -> void:
	line.emit_signal("level_completed")
	line.scale = Vector2.ONE * line.scale_factor.value
	
#	line._tween.interpolate_property(line, "global_position:y", line.global_position.y, target_position, 
#			0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
#	line._tween.start()
#	yield(line._tween, "tween_all_completed")
#	print(line.global_position.y)
	_state_machine.transition_to("Idle")

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
