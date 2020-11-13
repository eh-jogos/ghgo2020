# Write your doc string for this file here
tool
class_name DebugGroup
extends VBoxContainer

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

signal data_saved(data_dict)
signal loda_data_requested()

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var title: String = "Group Title" setget _set_title
export var title_font_size: int = 32 setget _set_title_font_size
export(Array, NodePath) var nodes_to_collapse: Array = []


#--- private variables - order: export > normal var > onready -------------------------------------

var _shared_variables_to_save: Array = []

onready var _group_title: PanelContainer = $DebugGroupTitle
onready var _title_button: Button = $DebugGroupTitle/Content/TitleButton

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	var canvas_item_list = []
	
	move_child(_group_title, 1)
	
	if Engine.editor_hint:
		return
	for node_path in nodes_to_collapse:
		var canvas_item: CanvasItem = get_node_or_null(node_path)
		if canvas_item != null:
			canvas_item_list.append(canvas_item)
	
	var collapsible = $DebugGroupTitle/Content/TitleButton/Collapsible
	collapsible._collapsibles = canvas_item_list
	collapsible.toggle_collapse(_title_button.pressed)
	
	for child in get_children():
		var node: Node = child
		if node is ReadOnlyDebugLine:
			continue
		
		for property_data in node.get_property_list():
			if _is_property_a_shared_variable(node, property_data):
				_shared_variables_to_save.append(node.get(property_data.name))

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func build_save_data() -> Dictionary:
	var save_data: = {}
	for index in _shared_variables_to_save.size():
		var shared_variable: SharedVariable = _shared_variables_to_save[index]
		if index == 0:
			save_data["collapsed_state"] = inst2dict(shared_variable)
		else:
			save_data[shared_variable.resource_path] = inst2dict(shared_variable)
	return save_data


func load_save_data(data: Dictionary) -> void:
	for path in data:
		if path == "collapsed_state":
			var bool_variable: BoolVariable = dict2inst(data[path])
			_title_button.pressed = bool_variable.value
			_title_button.emit_signal("toggled", _title_button.pressed)
		else:
			var shared_variable = load(path)
			shared_variable.value = dict2inst(data[path]).value

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_title(value: String) -> void:
	title = value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	if Engine.editor_hint and _title_button == null:
		_title_button = $DebugGroupTitle/Content/TitleButton
	
	_title_button.text = title


func _set_title_font_size(value: int) -> void:
	title_font_size = value
	if not is_inside_tree():
		yield(self, "ready")
	
	if Engine.editor_hint and _title_button == null:
		_title_button = $DebugGroupTitle/Content/TitleButton
	
	var dynamic_font: DynamicFont = _title_button.get_font("font")
	dynamic_font.size = title_font_size
	hide()
	show()


func _is_property_a_shared_variable(node: Node, property_data: Dictionary) -> bool:
	var is_shared_variable = (
		property_data.usage >= PROPERTY_USAGE_SCRIPT_VARIABLE
		and property_data["class_name"] == "Resource"
		and node.get(property_data.name) is SharedVariable
	)
	return is_shared_variable


func _on_Collapsible_collapsed_status_changed():
	hide()
	show()


func _on_Save_pressed():
	var save_data = build_save_data()
	emit_signal("data_saved", save_data)


func _on_Open_pressed():
	emit_signal("loda_data_requested")

### -----------------------------------------------------------------------------------------------
