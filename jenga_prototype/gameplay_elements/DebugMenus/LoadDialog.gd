# Write your doc string for this file here
extends FileDialog

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

var _save_handler: Node

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	eh_Utility.connect_signal(self, "file_selected", self, "_on_file_selected")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func open_load_dialog(p_save_handler: Node, filter: = "*.cat ; Text File") -> void:
	clear_filters()
	add_filter(filter)
	_save_handler = p_save_handler
	popup_centered()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_file_selected(file_path: String) -> void:
	var file = File.new()
	var error = file.open(file_path, File.READ)
	if not error == OK:
		push_error("Error %s | Failed to open file %s"%[error, file_path])
	
	var json_data = file.get_as_text()
	file.close()
	
	var parsed_json = parse_json(json_data)
	if parsed_json is Dictionary:
		_save_handler.load_save_data(parsed_json)

### -----------------------------------------------------------------------------------------------
