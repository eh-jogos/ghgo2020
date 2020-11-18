# Write your doc string for this file here
extends Node2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var scale_factor = 1.0

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _resources: ResourcePreloader = $ResourcePreloader
onready var _cup_spawn_point = $HUDLayer/HUD/SpawnCups/SpawnPivot/CupSpawnPoint
onready var _cups_layer: Node2D = $Cups
onready var _mouse_guide: Sprite = $MouseGuide
onready var _camera: Camera2D = $JengaCamera

onready var _scale_factor: FloatVariable = _resources.get_resource("scale_factor")
onready var _scale_increment: FloatVariable = _resources.get_resource("scale_increment")

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	
	pass

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func add_cup() -> void:
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

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_SpawnCups_pressed():
	add_cup()


func _on_TargetLine_level_completed():
	clear_cups()
	_scale_factor.value += _scale_increment.value
	_camera.update_zoom()


### -----------------------------------------------------------------------------------------------


