# Write your doc string for this file here
extends StaticBody2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

enum WallPosition {
	LEFT,
	RIGHT
}

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------


#--- private variables - order: export > normal var > onready -------------------------------------
export(WallPosition) var reference_position: = WallPosition.LEFT 
export var _path_reference: NodePath = NodePath()

onready var _refefence_black_bar: Control = get_node(_path_reference) as Control

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	yield(owner, "ready")
	match_reference_position()
	_refefence_black_bar.connect("item_rect_changed", self, 
			"_on_refefence_black_bar_item_rect_changed")
	

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func match_reference_position() -> void:
	match reference_position:
		WallPosition.LEFT:
			position.x = _refefence_black_bar.rect_size.x + _refefence_black_bar.rect_position.x
		WallPosition.RIGHT:
			position.x = _refefence_black_bar.rect_position.x

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_refefence_black_bar_item_rect_changed() -> void:
	match_reference_position()

### -----------------------------------------------------------------------------------------------
