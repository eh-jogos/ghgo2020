# Write your doc string for this file here
extends Node2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

var _debug_camera: Camera2D = null

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	_debug_camera = $JengaCamera
	set_process_input(false)
	
	if eh_Utility.is_standalone_run(self):
		_debug_camera.make_current()
		set_process_input(true)
	else:
		_debug_camera.queue_free()


func _input(event):
	
	if event.is_action_pressed("jenga_rotate_clockwise"):
		_debug_camera.zoom += Vector2.ONE * 0.1
	elif event.is_action_pressed("jenga_rotate_anti_clockwise"):
		if _debug_camera.zoom > Vector2.ONE * 0.15:
			_debug_camera.zoom -= Vector2.ONE * 0.05
	
	var direction = Vector2(
		event.get_action_strength("ui_right") - event.get_action_strength("ui_left"),
		event.get_action_strength("ui_down") - event.get_action_strength("ui_up")
	)
	_debug_camera.position += direction.normalized() * 100

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
