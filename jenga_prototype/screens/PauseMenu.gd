# Write your doc string for this file here
extends Popup

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

onready var quit_button: Button = $VBoxContainer/QuitButton

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	if OS.has_feature("web"):
		quit_button.hide()

func _unhandled_input(event):
	if event.is_action_pressed("pause_game"):
		if visible:
			close_pause_menu()
		else:
			open_pause_menu()

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func open_pause_menu() -> void:
	popup()
	get_tree().paused = true


func close_pause_menu() -> void:
	get_tree().paused = false
	hide()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_Resume_pressed():
	close_pause_menu()
