# Write your doc string for this file here
extends FileDialog

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

var _data: = {}

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	eh_Utility.connect_signal(self, "file_selected", self, "_on_file_selected")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func open_save_dialog(
		p_file_name: String, 
		p_data: Dictionary, 
		filter: = "*.cat ; Text File"
) -> void:
	clear_filters()
	add_filter(filter)
	current_file = p_file_name
	_data = p_data
	popup_centered()


func save_file(file_path: String) -> void:
	var file: = File.new()
	var success = file.open(file_path, File.WRITE)
	if not success == OK:
		push_error("Failed to open %s"%[file_path])
		return
	
	file.store_string(JSON.print(_data, " "))
	
	file.close()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_file_selected(file_path: String) -> void:
	save_file(file_path)

### -----------------------------------------------------------------------------------------------
