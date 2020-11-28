# Write your doc string for this file here
class_name PauseMenu
extends Popup

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

export var _nodepath_variable: Resource
export var _nodepath_cursor: Resource

var _cursor: Sprite

onready var _menu_button: TextureButton = $MenuButton
onready var _quit_button: TextureButton = $VBoxContainer/QuitButton
onready var _animator: AnimationPlayer = $AnimationPlayer

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	if OS.has_feature("web"):
		_quit_button.hide()
	
	if _nodepath_variable:
		_nodepath_variable.value = get_path()
	else:
		push_error("Pause Menu is missing it's nodepath_variable")
		assert(false)


func _unhandled_input(event):
	if event.is_action_pressed("pause_game"):
		if visible:
			close_pause_menu()
		else:
			open_pause_menu()

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func open_pause_menu() -> void:
	_menu_button.pressed = true
	
	if not _cursor:
		_cursor = get_node(_nodepath_cursor.value)
	_cursor.hide()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	popup()
	get_tree().paused = true
	
	_animator.play("open")


func close_pause_menu() -> void:
	if not _cursor:
		_cursor = _nodepath_cursor.get_node()
	_cursor.show()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	
	_animator.play("close")

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_QuitButton_pressed():
	get_tree().quit()

### -----------------------------------------------------------------------------------------------
