# Write your doc string for this file here
extends TextureButton

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const STARTING_X = 604
const HOVER_X = 10

#--- public variables - order: export > normal var > onready --------------------------------------

var tween: Tween

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	yield(owner, "ready")
	tween = owner.tween

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


func _on_HideShowPromptButton_mouse_entered():
	var final_x = 0
	if pressed:
		final_x = STARTING_X + HOVER_X
	else:
		final_x = STARTING_X - HOVER_X
	
	if tween.is_active():
		tween.remove(self)
	
	tween.interpolate_property(self, "rect_position:x", rect_position.x, final_x, 0.3, 
			Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	pass


func _on_HideShowPromptButton_mouse_exited():
	if tween.is_active():
		tween.remove(self)
	
	tween.interpolate_property(self, "rect_position:x", rect_position.x, STARTING_X, 0.3, 
			Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()


func _on_HideShowPromptButton_toggled(button_pressed):
	if button_pressed:
		rect_scale.x = -1
	else:
		rect_scale.x = 1
	
	owner.is_collapsed = button_pressed
