# Write your doc string for this file here
extends Node2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var level_current: IntVariable
var level_list: ArrayVariable

# then search where they are currently used/incremented and change the logic so that the increment
# happens here, but the animation in responde there. Then try to make it work with teh debug menu

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _resources: ResourcePreloader = $ResourcePreloader
onready var _cup_spawn_point = $HUDLayer/HUD/SpawnCups/SpawnPivot/CupSpawnPoint
onready var _cups_layer: Node2D = $Cups
onready var _mouse_guide: Sprite = $MouseGuide
onready var _camera: Camera2D = $JengaCamera

onready var _target_height: FloatVariable = _resources.get_resource("target_height")
onready var _camera_level: FloatVariable = _resources.get_resource("camera_level")
onready var _altered_bar_total: IntVariable = _resources.get_resource("max_value")
onready var _altered_bar_increment: IntVariable = _resources.get_resource("increment_step")
onready var _altered_state_increment: FloatVariable = _resources.get_resource("altered_increment")
onready var _scale_factor: FloatVariable = _resources.get_resource("scale_factor")


### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	level_current = _resources.get_resource("level_current")
	level_list = _resources.get_resource("levels_list")
	setup_current_level()
	level_current.connect_to(self, "_on_level_current_value_updated")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func add_cup() -> void:
	if not _mouse_guide.is_full:
		_mouse_guide.is_full = true
		
		var new_cup: BaseCup = _resources.get_resource("cup").instance()
		var canvas_transform = get_canvas_transform()
		var canvas_origin = -canvas_transform.origin * _camera.zoom
		var guide_position = _cup_spawn_point.rect_global_position * _camera.zoom
		
		new_cup.global_position = canvas_origin + guide_position
		_cups_layer.add_child(new_cup, true)


func clear_cups() -> void:
	for cup in _cups_layer.get_children():
		_cups_layer.remove_child(cup)
		cup.queue_free()


func setup_current_level() -> void:
	if level_current.value < level_list.value.size():
		var current_level: LevelData = level_list.value[level_current.value]
		
		_target_height.value = current_level.target_height
		_camera_level.value = current_level.camera_level
		_altered_bar_total.value = current_level.altered_bar_total
		_altered_bar_increment.value = current_level.altered_bar_increment
		_altered_state_increment.value = current_level.altered_state_increment
		
		if _scale_factor.value != current_level.cup_scale:
			clear_cups()
		
		_scale_factor.value = current_level.cup_scale

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_SpawnCups_pressed():
	add_cup()


func _on_TargetLine_level_completed():
	clear_cups()
	if level_current.value + 1 >= level_list.value.size():
		#won game
		pass
	else:
		level_current.value += 1


func _on_level_current_value_updated() -> void:
	setup_current_level()

### -----------------------------------------------------------------------------------------------


