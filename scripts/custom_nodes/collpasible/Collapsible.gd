# Write your doc string for this file here
class_name Collapsible
extends Node

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

signal collapsed_status_changed

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var toggle_button_path: = NodePath("..")
export(Array, NodePath) var collapsible_node_paths: Array = []
export var expanded_text: String = ""
export var collapsed_text: String = ""
export var expanded_icon: Texture = null
export var collapsed_icon: Texture = null

#--- private variables - order: export > normal var > onready -------------------------------------

var _collapsibles: Array = []
var _ready_collapsibles: Array = []

onready var _toggle_button: Button = get_node_or_null(toggle_button_path)

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	if collapsible_node_paths.empty():
		return
	
	for node_path in collapsible_node_paths:
		var canvas_item: CanvasItem = get_node_or_null(node_path)
		if canvas_item == null:
			collapsible_node_paths.erase(node_path)
		else:
			_collapsibles.append(canvas_item)
	
	if _toggle_button != null:
		toggle_collapse(_toggle_button.pressed)
	
		if not _toggle_button.is_connected("toggled", self, "_on_toggle_button_togled"):
			# warning-ignore:return_value_discarded
			_toggle_button.connect("toggled", self, "_on_toggle_button_togled")
#
#		for canvas_item in _collapsibles:
#			if not canvas_item.is_connected("ready", self, "_on_collapsible_ready"):
#				# warning-ignore:return_value_discarded
#				canvas_item.connect("ready", self, "_on_collapsible_ready")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func toggle_collapse(is_pressed: bool) -> void:
	for canvas_item in _collapsibles:
		canvas_item.visible = is_pressed
	
	if is_pressed:
		if expanded_text != "":
			_toggle_button.text = expanded_text
		
		if expanded_icon != null:
			_toggle_button.icon = expanded_icon
	else:
		if collapsed_text != "":
			_toggle_button.text = collapsed_text
		
		if collapsed_icon != null:
			_toggle_button.icon = collapsed_icon
	
	emit_signal("collapsed_status_changed")


### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_collapsible_ready() -> void:
	_ready_collapsibles.append(true)
	if _ready_collapsibles.size() == _collapsibles.size():
		toggle_collapse(_toggle_button.pressed)


func _on_toggle_button_togled(is_pressed: bool) -> void:
	toggle_collapse(is_pressed)

### -----------------------------------------------------------------------------------------------
