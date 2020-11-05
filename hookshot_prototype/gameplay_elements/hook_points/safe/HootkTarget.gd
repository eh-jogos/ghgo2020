# Area2D the Hook can hook onto
# If is_one_shot is true, the player can only hook onto the point once
class_name HookTarget
extends Area2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

signal hooked_onto_from(hook_position)

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var is_one_shot: = false

var is_active: = true setget _set_is_active

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _timer: Timer = $Timer

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	if not visible:
		self.is_active = false

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func hooked_from(hook_position: Vector2) -> void:
	self.is_active = false
	emit_signal("hooked_onto_from", hook_position)

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_is_active(value:bool) -> void:
	if not visible:
		is_active = false
	else:
		is_active = value
		
		if not is_active and not is_one_shot:
			_timer.start()


func _on_Timer_timeout():
	self.is_active = true


func _on_HootkTarget_visibility_changed():
	if not visible:
		self.is_active = false

### -----------------------------------------------------------------------------------------------
