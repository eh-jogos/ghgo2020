# Write your doc string for this file here
extends Sprite

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var rawr_countdown: int = 15

var idle_count: int

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _animator: AnimationPlayer = $AnimationPlayer

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	idle_count = rawr_countdown
	pass

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "idle":
		idle_count -= 1
	
	if idle_count == 0:
		idle_count = rawr_countdown
		_animator.play("rawr")
	else:
		_animator.play("idle")

### -----------------------------------------------------------------------------------------------
