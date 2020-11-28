# Write your doc string for this file here
extends StaticBody2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var level_to_disappear: int = 4
export var current_level: Resource

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _collision: CollisionPolygon2D = $CollisionPolygon2D

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	current_level = current_level as IntVariable
	if current_level != null:
		set_table(current_level.value)
		current_level.connect_to(self, "_on_current_level_valur_updated")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func set_table(level_number: int) -> void:
	if level_number >= level_to_disappear:
		hide()
		_collision.disabled = true
	else:
		show()
		_collision.disabled = false

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_current_level_valur_updated() -> void:
	set_table(current_level.value)

### -----------------------------------------------------------------------------------------------
