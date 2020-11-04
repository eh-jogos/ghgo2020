# Write your doc string for this file here
class_name Player
extends KinematicBody2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const FLOOR_NORMAL: = Vector2.UP

#--- public variables - order: export > normal var > onready --------------------------------------

var is_active: = false setget _set_is_active

onready var state_machine: StateMachine = $PlayerStateMachine
onready var collider: CollisionShape2D = $CollisionShape2D
onready var skin: Node2D = $Skin

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	pass

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_is_active(value: bool) -> void:
	is_active = value
	collider.disabled = not is_active

### -----------------------------------------------------------------------------------------------
