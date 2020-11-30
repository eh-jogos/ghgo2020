# Write your doc string for this file here
extends Control

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const POSITION_OPEN = 0
const POSITION_CLOSED = -600

#--- public variables - order: export > normal var > onready --------------------------------------

var is_collapsed = false setget _set_is_collapsed

onready var tween: Tween = $Tween

#--- private variables - order: export > normal var > onready -------------------------------------

export var _nodepath_mouse_guide: Resource
export var _nodepath_cursor: Resource

var _mouse_guide: Sprite
var _cursor: Sprite

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	pass

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_is_collapsed(value: bool) -> void:
	is_collapsed = value
	
	if tween.is_active():
		tween.remove(self)
	
	if is_collapsed:
		tween.interpolate_property(self, "rect_position:x", rect_position.x, POSITION_CLOSED,
				0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	else:
		tween.interpolate_property(self, "rect_position:x", rect_position.x, POSITION_OPEN,
				0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	
	tween.start()

### -----------------------------------------------------------------------------------------------


func _on_PromptsGameplay_mouse_entered():
	if not _cursor:
		_cursor = get_node(_nodepath_cursor.value)
	if not _mouse_guide:
		_mouse_guide = get_node(_nodepath_mouse_guide.value)
	_cursor.hide()
	_mouse_guide.hide()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_PromptsGameplay_mouse_exited():
	if not _cursor:
		_cursor = get_node(_nodepath_cursor.value)
	if not _mouse_guide:
		_mouse_guide = get_node(_nodepath_mouse_guide.value)
	_cursor.show()
	_mouse_guide.show()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
