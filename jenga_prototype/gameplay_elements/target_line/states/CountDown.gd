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

func physics_process(_delta: float) -> void:
	if not line.has_overlapping_bodies_in_rest():
		_state_machine.transition_to("Idle")


func enter(_msg: Dictionary = {}) -> void:
	line._animator.play("countdown")
	line._timer.start()
	
	eh_Utility.connect_signal(line._timer, "timeout", self, "_on_timer_timeout")


func exit() -> void:
	eh_Utility.disconnect_signal(line._timer, "timeout", self, "_on_timer_timeout")

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_timer_timeout() -> void:
	_state_machine.transition_to("Win")

### -----------------------------------------------------------------------------------------------
