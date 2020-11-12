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
	
	node.set_as_toplevel(to_toplevel)
	
	if node is Control:
		node.rect_global_position = current_pos
	else:
		node.global_position = current_pos


static func connect_signal(
		from_object: Object, 
		signal_name: String, 
		to_object: Object, 
		func_name: String,
		binds: = [],
		flag: = 0
	) -> void:
	if not from_object.is_connected(signal_name, to_object, func_name):
		var error = from_object.connect(signal_name, to_object, func_name, binds, flag)
		if error != 0:
			push_error("Signal Connection Failed: %s, %s, %s, %s | Error: %s"%[
				signal_name,
				from_object,
				to_object,
				func_name,
				error
			])


static func disconnect_signal(
	from_object: Object, 
	signal_name: String, 
	to_object: Object, 
	func_name: String
	) -> void:
	if from_object.is_connected(signal_name, to_object, func_name):
		from_object.disconnect(signal_name, to_object, func_name)


### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
