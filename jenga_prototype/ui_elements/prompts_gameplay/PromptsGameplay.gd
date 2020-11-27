# Write your doc string for this file here
extends Control

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const POSITION_OPEN = 0
const POSITION_CLOSED = -600

#--- public variables - order: export > normal var > onready --------------------------------------

var is_collapsed = false setget _set_is_collapsed

onready var tween: Tween = $Tween

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	pass

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_is_collapsed(value: bool) -> void:
	is_collapsed = value
	
	if tween.is_active():
		tween.remove(self)
	
	if is_collapsed:
		tween.interpolate_property(self, "rect_position:x", rect_position.x, POSITION_CLOSED,
				0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	else:
		tween.interpolate_property(self, "rect_position:x", rect_position.x, POSITION_OPEN,
				0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	
	tween.start()

### -----------------------------------------------------------------------------------------------
