# Write your doc string for this file here
class_name TargetLine
extends Area2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

signal level_completed

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export(Resource) var sensibility = null

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _timer: Timer = $Timer
onready var _tween: Tween = $Tween
onready var _animator: AnimationPlayer = $AnimationPlayer

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	pass

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func has_overlapping_bodies_in_rest() -> bool:
	var bodies = get_overlapping_bodies()
	var is_at_least_one_body_touching_line: = false
	for body in bodies:
		var cup: BaseCup = body.get_parent() as BaseCup
		if cup == null:
			continue
			
		if is_cup_in_rest(cup):
			is_at_least_one_body_touching_line = true
			break
	
	return is_at_least_one_body_touching_line


func is_cup_in_rest(cup: BaseCup) -> bool:
	var is_in_rest: bool = \
			cup.state_machine._state_name == "Dropped" \
			and cup.main_rigid_body.linear_velocity.y > - sensibility.value \
			and cup.main_rigid_body.linear_velocity.y < sensibility.value
	return is_in_rest

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
