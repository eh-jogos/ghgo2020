# Write your doc string for this file here
extends Label

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var altered_value: int = 0 setget _set_altered_value

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _effect_label: Label = $NumberEffect
onready var _animator: AnimationPlayer = $AnimationPlayer

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	pass

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_altered_value(p_value: int) -> void:
	altered_value = p_value
	text = str(altered_value)
	_effect_label.text = str(altered_value)
	_animator.play("pulse")

### -----------------------------------------------------------------------------------------------
