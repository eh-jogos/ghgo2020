# Write your doc string for this file here
extends Node2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var hook_position: Vector2 = Vector2.ZERO setget _set_hook_position
var length: float = 40.0 setget _set_length

#--- private variables - order: export > normal var > onready -------------------------------------

var head_tracking_position = Vector2.INF

onready var _tween: Tween = $Tween
onready var _tail: Line2D = $Tail
onready var _head: Sprite = $Head

onready var start_length: float = _head.position.x

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _physics_process(delta):
	if head_tracking_position == Vector2.INF:
		return
	
	_head.global_position = head_tracking_position
	var distance = head_tracking_position - global_position
	rotation = distance.angle()
	_set_length(distance.length())

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func release_hook() -> void:
	head_tracking_position = Vector2.INF
	_head.position.y = 0
	
	_tween.interpolate_property(
			self, "length", length, start_length, 
			0.25, Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	_tween.start()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_hook_position(value: Vector2) -> void:
	hook_position = value
	
	var vector_to_target: = hook_position - global_position
	rotation = vector_to_target.angle()
	_set_length(vector_to_target.length())
	head_tracking_position = _head.global_position

func _set_length(value: float) -> void:
	length = value
	_tail.points[-1].x = length - _head.texture.get_height()
	if head_tracking_position == Vector2.INF:
		if value != start_length:
			_head.position.x = _tail.points[-1].x + _tail.position.x - _head.texture.get_height()
		else:
			_head.position.x = _tail.points[-1].x + _tail.position.x
	
### -----------------------------------------------------------------------------------------------
