# Write your doc string for this file here
extends Control

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

export var _target_line_height: Resource
export var _node_path_variable: Resource

onready var _tween: Tween = $Tween

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	_node_path_variable.value = self.get_path()
	
	anchor_top = 1 - _target_line_height.value
	eh_Utility.connect_signal(_target_line_height, "value_updated", 
			self, "_on_target_line_value_updated")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_target_line_value_updated() -> void:
	if _tween.is_active():	
		_tween.remove_all()
	
	var new_anchor = 1 - _target_line_height.value
	_tween.interpolate_property(self, "anchor_top", anchor_top, new_anchor, 
			0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	_tween.start()

### -----------------------------------------------------------------------------------------------
