# Write your doc string for this file here
class_name TargetLine
extends Area2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

signal level_completed

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var sensibility: FloatVariable
var camera: Camera2D
var camera_level: FloatVariable

var effect_bottle: Sprite

#--- private variables - order: export > normal var > onready -------------------------------------

var _path_progress_bar: NodePathVariable
var _progress_bar: ProgressBar

var _target_line_path: NodePathVariable
var _guide_path: NodePathVariable
var _target_line_guide: Control

var _camera_path: NodePathVariable

var _levels_list: ArrayVariable
var _level_current: IntVariable

onready var _timer: Timer = $Timer
onready var _tween: Tween = $Tween
onready var _animator: AnimationPlayer = $AnimationPlayer
onready var _resources: ResourcePreloader = $ResourcePreloader

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	_setup_shared_variables()


func _process(_delta):
	if _target_line_guide and camera:
		var final_position = _convert_from_hud_position(_target_line_guide.rect_global_position)
		scale = camera.zoom
		global_position.y = final_position.y

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
			and cup.main_rigid_body.linear_velocity.y > - sensibility.value * camera.zoom.y \
			and cup.main_rigid_body.linear_velocity.y < sensibility.value * camera.zoom.y
	return is_in_rest

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _convert_from_hud_position(hud_position: Vector2) -> Vector2:
	var canvas_transform = get_canvas_transform()
	var canvas_origin = -canvas_transform.origin * camera.zoom
	var reference_position = hud_position * camera.zoom
	var final_position = canvas_origin + reference_position
	
	return final_position


func _setup_shared_variables() -> void:
	sensibility = _resources.get_resource("target_line_sensibility")
	_levels_list = _resources.get_resource("levels_list")
	_level_current = _resources.get_resource("level_current")
	
	_guide_path = _resources.get_resource("target_line_guide")
	_camera_path = _resources.get_resource("main_camera")
	
	_target_line_path = _resources.get_resource("target_line")
	_target_line_path.value = self.get_path()
	
	_target_line_guide = get_node_or_null(_guide_path.value)
	if not _target_line_guide:
		_guide_path.connect_to(self, "_on_guide_path_value_updated")
	
	camera = get_node_or_null(_camera_path.value)
	if not camera:
		_camera_path.connect_to(self, "_on_camera_path_value_updated")
	
	_path_progress_bar = _resources.get_resource("progress_bar")
	_progress_bar = get_node_or_null(_path_progress_bar.value)


func _on_guide_path_value_updated() -> void:
	_target_line_guide = get_node_or_null(_guide_path.value)


func _on_camera_path_value_updated() -> void:
	camera = get_node_or_null(_camera_path.value)


func _on_TargetLine_level_completed():
	if not Events.is_connected("zoom_updated", self, "_on_Events_zoom_updated"):
		Events.connect("zoom_updated", self, "_on_Events_zoom_updated")


func _on_Events_zoom_updated() -> void:
	print("BOTTLE ANIMATION")
	effect_bottle = $Line/Tag/Bottle.duplicate()
	$Line/Tag.add_child(effect_bottle, true)
	var bottle_position = effect_bottle.global_position
	effect_bottle.set_as_toplevel(true)
	effect_bottle.global_position = bottle_position
	effect_bottle.scale *= camera.zoom
	
	if not _progress_bar:
		_progress_bar = get_node(_path_progress_bar.value)
	
	var final_position = _convert_from_hud_position(_progress_bar.rect_global_position)
	final_position += _progress_bar.rect_size/2 * camera.zoom
	
	var duration = 0.8
	
	_tween.interpolate_property(effect_bottle, "global_position", effect_bottle.global_position, 
			final_position, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)

	_tween.interpolate_property(effect_bottle, "scale", effect_bottle.scale, 
			effect_bottle.scale*2, duration/2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	_tween.interpolate_property(effect_bottle, "scale", effect_bottle.scale*2, 
			effect_bottle.scale/2, duration/2, Tween.TRANS_QUAD, Tween.EASE_IN, duration/2)

	_tween.interpolate_property(effect_bottle, "modulate:a", effect_bottle.modulate.a, 1.0,
			duration/2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	_tween.interpolate_property(effect_bottle, "modulate:a", 1.0, 0.0,
			duration/2, Tween.TRANS_QUAD, Tween.EASE_IN, duration/2)
	_tween.start()
	
	yield(_tween, "tween_all_completed")
	
	effect_bottle.queue_free()
	var previous_level: LevelData = _levels_list.value[_level_current.value - 1]
	_progress_bar.decrement_altered_progress(previous_level.altered_bar_win_bonus)

### -----------------------------------------------------------------------------------------------
