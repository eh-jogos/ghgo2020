# Write your doc string for this file here
extends Camera2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export(float, 0, 1, 0.01) var camera_level: float = 0.0 setget _set_camera_level
export var anchor_start: Vector2 = Vector2(960,705)
export var anchor_end: Vector2 = Vector2(960,-3250)
export var anchor_min_zoom: float = 0.5
export var anchor_max_zoom: float = 8.45

var difference_anchor: Vector2
var difference_zoom: float

#--- private variables - order: export > normal var > onready -------------------------------------

var _target_line: TargetLine
var _target_line_path: NodePathVariable

onready var _resources: ResourcePreloader = $ResourcePreloader
onready var _tween: Tween = $Tween

onready var _camera_level: FloatVariable = _resources.get_resource("camera_level")
onready var _camera_path: NodePathVariable = _resources.get_resource("main_camera")

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	_camera_path.value = self.get_path()
	
	difference_anchor = anchor_end - anchor_start
	difference_zoom = anchor_max_zoom - anchor_min_zoom
	_set_camera_level(_camera_level.value)
	_camera_level.connect_to(self, "_on_camera_level_changed")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func update_zoom() -> void:
	if _tween.is_active():
		_tween.remove_all()
	
	var new_camera_level = _camera_level.value
	_tween.interpolate_property(self, "camera_level", camera_level, new_camera_level, 
			0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	_tween.start()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_camera_level(p_value: float) -> void:
	camera_level = clamp(p_value, 0, 1)
	
	difference_anchor = anchor_end - anchor_start
	difference_zoom = anchor_max_zoom - anchor_min_zoom
	
	position = anchor_start + (difference_anchor * camera_level)
	
	zoom = Vector2.ONE * (anchor_min_zoom + difference_zoom * camera_level)


func _on_camera_level_changed() -> void:
	update_zoom()

### -----------------------------------------------------------------------------------------------
