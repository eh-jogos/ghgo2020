# Write your doc string for this file here
extends DebugMenu

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------


#--- private variables - order: export > normal var > onready -------------------------------------

export var _nodepath_cursor: Resource

var _data_progression: Dictionary = {}
var _data_target_line: Dictionary = {}
var _data_altered_state: Dictionary = {}

onready var _group_progression: DebugGroup = $Panel/ScrollContainer/DebugList/ProgressionGroup
onready var _group_target_line: DebugGroup = $Panel/ScrollContainer/DebugList/TargetLineGroup
onready var _group_altered_state: DebugGroup = $Panel/ScrollContainer/DebugList/AlteredStateGroup

onready var _popup_save: FileDialog = $Popups/SaveDialog
onready var _popup_load: FileDialog = $Popups/LoadDialog

onready var _cursor: Sprite

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------


func open_debug_menu() -> void:
	if not _cursor:
		_cursor = get_node(_nodepath_cursor.value)
	
	_cursor.hide()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	.open_debug_menu()


func close_debug_menu() -> void:
	if not _cursor:
		_cursor = get_node(_nodepath_cursor.value)
	
	_cursor.show()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	.close_debug_menu()


func load_save_data(save_data: Dictionary) -> void:
	for key in save_data:
		match key:
			"progression":
				_group_progression.load_save_data(save_data[key])
			"target_line":
				_group_target_line.load_save_data(save_data[key])
			"altered_state":
				_group_altered_state.load_save_data(save_data[key])
			_:
				push_error("Unregistered save_data category: %s"%[key])
				assert(false)

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_ProgressionGroup_data_saved(data_dict: Dictionary) -> void:
	_data_progression = data_dict
	_popup_save.open_save_dialog("ProgressionData", _data_progression)


func _on_TargetLineGroup_data_saved(data_dict: Dictionary) -> void:
	_data_target_line = data_dict
	_popup_save.open_save_dialog("TargetLineData", _data_target_line)


func _on_AlteredStateGroup_data_saved(data_dict: Dictionary) -> void:
	_data_altered_state = data_dict
	_popup_save.open_save_dialog("AlteredStateData", _data_altered_state)


func _on_ProgressionGroup_loda_data_requested():
	_popup_load.open_load_dialog(_group_progression)


func _on_TargetLineGroup_loda_data_requested():
	_popup_load.open_load_dialog(_group_target_line)


func _on_AlteredStateGroup_loda_data_requested():
	_popup_load.open_load_dialog(_group_altered_state)


func _on_SaveProfile_pressed():
	_data_progression = _group_progression.build_save_data()
	_data_target_line = _group_target_line.build_save_data()
	_data_altered_state = _group_altered_state.build_save_data()
	
	var data = {
		progression = _data_progression,
		target_line = _data_target_line,
		altered_state = _data_altered_state
	}
	
	_popup_save.open_save_dialog("Profile", data, "*.profile ; Text File")


func _on_Load_Profile_pressed():
	_popup_load.open_load_dialog(self, "*.profile ; Text File")

### -----------------------------------------------------------------------------------------------


func _on_SfxSpinBox_value_changed(value):
	var sfx_bus = AudioServer.get_bus_index("Sfx")
	var vol_db = linear2db(value)
	AudioServer.set_bus_volume_db(sfx_bus, vol_db)


func _on_MusicSpinBox_value_changed(value):
	var music_bus = AudioServer.get_bus_index("Music")
	var vol_db = linear2db(value)
	AudioServer.set_bus_volume_db(music_bus, vol_db)
