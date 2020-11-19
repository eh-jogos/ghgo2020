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
export var drink_count: Resource

var scale_factor: float = 1.0

#--- private variables - order: export > normal var > onready -------------------------------------

var _drink_increment: float = 0.2 

onready var _animation_player: AnimationPlayer = $AnimationPlayer

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func spawn() -> void:
	drink_count.value += 1
	var increment = _drink_increment * drink_count.value
	var new_speed = clamp(_animation_player.playback_speed + increment, 1.0, 3.0)
	_animation_player.playback_speed = new_speed
	_animation_player.play("spawn")


func drink() -> void:
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
