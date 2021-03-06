# Write your doc string for this file here
extends Node2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var level_current: IntVariable
var level_list: ArrayVariable
var reset_values: Dictionary = {
	"altered_factor": 0.0,
	"altered_bar_lifetime_value": 0,
}


#--- private variables - order: export > normal var > onready -------------------------------------

onready var _resources: ResourcePreloader = $ResourcePreloader
onready var _cup_spawn_point = $HUDLayer/GameHUD/SpawnCups/SpawnPivot/CupSpawnPoint
onready var _cups_layer: Node2D = $Cups
onready var _mouse_guide: Sprite = $MouseGuide
onready var _camera: Camera2D = $JengaCamera
onready var _progress_bar: ProgressBar = $HUDLayer/GameHUD/AlteredStateProgressBar
onready var _background: Node2D = $ParallaxBackgrounds

onready var _target_height: FloatVariable = _resources.get_resource("target_height")
onready var _camera_level: FloatVariable = _resources.get_resource("camera_level")
onready var _altered_bar_total: IntVariable = _resources.get_resource("max_value")
onready var _altered_bar_increment: IntVariable = _resources.get_resource("increment_step")
onready var _altered_state_increment: FloatVariable = _resources.get_resource("altered_increment")
onready var _altered_state: FloatVariable = _resources.get_resource("altered_factor")
onready var _scale_factor: FloatVariable = _resources.get_resource("scale_factor")
onready var _is_milkshake: BoolVariable = _resources.get_resource("is_milkshake")


### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	level_current = _resources.get_resource("level_current")
	level_list = load("res://jenga_prototype/shared_variables/levels/array_levels_list.tres")
	setup_current_level()
	level_current.connect_to(self, "_on_level_current_value_updated")
	yield(get_tree().create_timer(1), "timeout")
	for audio_child in $Tracks.get_children():
		audio_child.play()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jenga_reset"):
		reset_level()


func _input(event):
	if event.is_action_pressed("jenga_debug_ending") and OS.is_debug_build():
		_game_ending()

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func add_cup() -> void:
	if not _mouse_guide.is_full:
		_mouse_guide.is_full = true
		
		var new_cup: BaseCup
		if _is_milkshake.value:
			new_cup = _resources.get_resource("cup_milkshake").instance()
		else:
			new_cup = _resources.get_resource("cup").instance()
		var canvas_transform = get_canvas_transform()
		var canvas_origin = -canvas_transform.origin * _camera.zoom
		var guide_position = _cup_spawn_point.rect_global_position * _camera.zoom
		
		new_cup.global_position = canvas_origin + guide_position
		_cups_layer.add_child(new_cup, true)


func clear_cups() -> void:
	for cup in _cups_layer.get_children():
		if cup.state_machine._state_name == "Dropped":
			_cups_layer.remove_child(cup)
			cup.queue_free()


func update_cup_scale() -> void:
	for cup in _cups_layer.get_children():
		cup._handle_scale_factor()


func setup_current_level() -> void:
	if level_current.value < level_list.value.size():
		var current_level: LevelData = level_list.value[level_current.value]
		
		_target_height.value = current_level.target_height
		_camera_level.value = current_level.camera_level
		_altered_bar_total.value = current_level.altered_bar_total
		_altered_bar_increment.value = current_level.altered_bar_increment
		
		if _scale_factor.value != current_level.cup_scale:
			clear_cups()
		
		_scale_factor.value = current_level.cup_scale 
		update_cup_scale()


func reset_level() -> void:
	clear_cups()
	_altered_state.value = reset_values.altered_factor
	_progress_bar.reset_progress_bar_to(reset_values.altered_bar_lifetime_value)

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _game_ending() -> void:
	var _hud_animator: AnimationPlayer = $HUDLayer/AnimationPlayer
	_hud_animator.play("hide_hud")
	_camera.go_to_ending()
	_scale_factor.value = 3.0
	_altered_state.value = 0.0
	_mouse_guide.set_thumbs_up()
	yield(_camera._tween, "tween_all_completed")
	_background.show_ending()
	yield(_background._ending_animator, "animation_finished")
	_hud_animator.play("show_end_hud")


func _on_SpawnCups_pressed():
	add_cup()


func _on_TargetLine_level_completed():
	clear_cups()
	reset_values.altered_factor = _altered_state.value
	reset_values.altered_bar_lifetime_value = _progress_bar.lifetime_value
	
	if level_current.value + 1 >= level_list.value.size():
		_game_ending()
	else:
		level_current.value += 1


func _on_level_current_value_updated() -> void:
	setup_current_level()

### -----------------------------------------------------------------------------------------------


