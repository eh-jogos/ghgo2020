# Write your doc string for this file here
tool
extends Sprite

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var start_offset: float = 0.0 setget _set_start_offset
export var custom_scale: float = 1.0 setget _set_custom_scale

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _animator: AnimationPlayer = $AnimationPlayer

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	if not Engine.editor_hint:
#		_animator.playback_speed = randf() * (1.1 - 0.95) + 0.95
		_animator.play("idle")
		_set_start_offset(start_offset)
	pass

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_start_offset(value: float) -> void:
	start_offset = value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	var idle_length = _animator.get_animation("idle").length
	_animator.assigned_animation = "idle"
	_animator.seek(idle_length * start_offset, true)


func _set_custom_scale(value: float) -> void:
	custom_scale = value
	scale = Vector2.ONE * custom_scale

### -----------------------------------------------------------------------------------------------
