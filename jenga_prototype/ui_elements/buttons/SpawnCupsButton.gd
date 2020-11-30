# Write your doc string for this file here
extends TextureButton

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var color_normal: Color = Color.white
export var color_hover: Color = Color.white
export var color_pressed: Color = Color.white
export var is_milkshake: Resource

onready var icon_beer: Node2D = $IconPivot/Beer
onready var icon_milk_shake: Node2D = $IconPivot/MilkShake

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	if is_milkshake.value:
		icon_beer.hide()
		icon_milk_shake.show()
	else:
		icon_beer.show()
		icon_milk_shake.hide()

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_SpawnCups_mouse_entered():
	self_modulate = color_hover


func _on_SpawnCups_mouse_exited():
	self_modulate = color_normal


func _on_SpawnCups_button_down():
	self_modulate = color_pressed


func _on_SpawnCups_button_up():
	self_modulate = color_normal

### -----------------------------------------------------------------------------------------------
