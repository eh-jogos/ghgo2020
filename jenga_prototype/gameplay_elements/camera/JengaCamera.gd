# Write your doc string for this file here
extends Camera2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const DEFAULT_SHAKE_OFFSET = Vector2(80, 60)

#--- public variables - order: export > normal var > onready --------------------------------------

export(float, 0, 1, 0.01) var camera_level: float = 0.0 setget _set_camera_level
export var anchor_start: Vector2 = Vector2(960,705)
export var anchor_end: Vector2 = Vector2(960,-3250)
export var anchor_min_zoom: float = 0.5
export var anchor_max_zoom: float = 8.45

export var end_position: Vector2 = Vector2(960, -5490)
export var end_zoom: float = 3

var difference_anchor: Vector2
var difference_zoom: float

#--- private variables - order: export > normal var > onready -------------------------------------

var _target_line: TargetLine
var _target_line_path: NodePathVariable

onready var _resources: ResourcePreloader = $ResourcePreloader
onready var _tween: Tween = $Tween
onready var _sfx_swoosh: SfxLibrary = $SfxSwoosh
onready var _shaker: Shaker = $Shaker

onready var _camera_level: FloatVariable = _resources.get_resource("camera_level")
onready var _camera_path: NodePathVariable = _resources.get_resource("main_camera")
onready var _current_level: IntVariable = _resources.get_resource("int_level_current")

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	_camera_path.value = self.get_path()
	
	difference_anchor = anchor_end - anchor_start
	difference_zoom = anchor_max_zoom - anchor_min_zoom
	_set_camera_level(_camera_level.value)
	_camera_level.connect_to(self, "_on_camera_level_changed")
	
	eh_Utility.connect_signal(Events, "ground_collided", self, "_on_Events_ground_collided")
	eh_Utility.connect_signal(Events, "cup_collided", self, "_on_Events_cup_collided")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func update_zoom() -> void:
	if _tween.is_active():
		_tween.remove_all()
	
	var new_camera_level = _camera_level.value
	_tween.interpolate_property(self, "camera_level", camera_level, new_camera_level, 
			0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	_tween.start()
	
	_sfx_swoosh.play()
	
	yield(_tween, "tween_completed")
	
	Events.emit_signal("zoom_updated")


func go_to_ending() -> void:
	_tween.interpolate_property(self, "position", position, end_position, 
			1.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	_tween.interpolate_property(self, "zoom", zoom, Vector2.ONE * end_zoom,
			1.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	_tween.start()
	_sfx_swoosh.play()

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


func _shake_camera(is_halved: = false) -> void:
	if _current_level.value < 4:
		return
	
	_shaker.max_offset = DEFAULT_SHAKE_OFFSET * camera_level
	if _current_level.value == 7:
		_shaker.max_offset *= 5
	elif _current_level.value == 6:
		_shaker.max_offset *= 3
	
	if _shaker.trauma == 0:
		var trauma = 1.0 if not is_halved else 0.7
		_shaker.add_trauma(trauma)


func _on_Events_ground_collided() -> void:
	_shake_camera()


func _on_Events_cup_collided() -> void:
	_shake_camera(true)

### -----------------------------------------------------------------------------------------------
