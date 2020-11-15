# Write your doc string for this file here
tool
class_name CupSkin
extends Node2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

signal animation_finished

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var custom_scale: Vector2 = Vector2.ONE setget _set_custom_scale
export var altered_state_factor: Resource

var scale_factor: float = 1.0

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _animation_player: AnimationPlayer = $AnimationPlayer

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func spawn() -> void:
	_animation_player.playback_speed = 1.0 + altered_state_factor.value
	_animation_player.play("spawn")


func drink() -> void:
	_animation_player.playback_speed = 1.0 + altered_state_factor.value
	_animation_player.play("drink")

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != "BASE":
		emit_signal("animation_finished")


func _set_custom_scale(value: Vector2) -> void:
	custom_scale = value
	scale = custom_scale * scale_factor

### -----------------------------------------------------------------------------------------------
