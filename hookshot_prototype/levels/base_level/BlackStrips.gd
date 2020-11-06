# Write your doc string for this file here
tool
extends Control

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export(float, -0.5, 0.5, 0.01) var center: float = 0.0 setget _set_center
export(float, 0.0, 1.0, 0.01) var open_area: float = 0.0 setget _set_open_area

#--- private variables - order: export > normal var > onready -------------------------------------

var midpoint: float = 0.5

onready var _left: ColorRect = $Left
onready var _right: ColorRect = $Right

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	midpoint = 0.5 + center
	pass

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_center(value: float) -> void:
	center = value
	midpoint = 0.5 + center
	
	if not is_inside_tree():
		yield(self, "ready")
	
	_set_open_area(open_area)


func _set_open_area(value: float) -> void:
	open_area = value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	_left.anchor_right = midpoint - open_area / 2
	_left.margin_right = 0
	_right.anchor_left = midpoint + open_area /2
	_right.margin_left = 0

### -----------------------------------------------------------------------------------------------
