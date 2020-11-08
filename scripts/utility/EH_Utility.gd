# Write your doc string for this file here
class_name eh_Utility
extends Reference

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

static func set_node_as_toplevel(node: CanvasItem, to_toplevel: bool) -> void:
	var current_pos: Vector2 = Vector2.ZERO
	if node is Control:
		current_pos = node.rect_global_position
	else:
		current_pos = node.global_position
	
	node.set_as_toplevel(true)
	
	if node is Control:
		node.rect_global_position = current_pos
	else:
		node.global_position = current_pos

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
