# Write your doc string for this file here
extends KinematicBody2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

enum FacingDirection {
	LEFT,
	RIGHT
}

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export(FacingDirection) var facing: int = FacingDirection.LEFT setget _set_facing
export var speed: float = 200
export var gravity: float = 980

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _animator: AnimationPlayer = $AnimationPlayer

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _physics_process(delta) -> void:
	var direction = Vector2.LEFT if facing == FacingDirection.LEFT else Vector2.RIGHT
	var velocity = direction * speed * delta
	move_and_slide(velocity, Vector2.UP)

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func fade_out() -> void:
	_animator.play("fade_out")


func invert_movement() -> void:
	if facing == FacingDirection.LEFT:
		_set_facing(FacingDirection.RIGHT)
	else:
		_set_facing(FacingDirection.LEFT)
	
	_animator.play("fade_in")

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_facing(value: int) -> void:
	facing = value
	if facing == FacingDirection.RIGHT:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

### -----------------------------------------------------------------------------------------------
