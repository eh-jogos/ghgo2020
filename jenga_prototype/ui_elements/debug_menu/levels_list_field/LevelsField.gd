# Write your doc string for this file here
extends VBoxContainer

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _resources: ResourcePreloader = $ResourcePreloader
onready var _levels: VBoxContainer = $LevelsIdentation/Levels
onready var _levels_list: ArrayVariable = _resources.get_resource("array_levels_list")
onready var _current_level: IntVariable = _resources.get_resource("int_level_current")

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	populate_levels_list()

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func populate_levels_list() -> void:
	for level_data in _levels_list.value:
		var new_instance = _resources.get_resource("LevelDataField").instance()
		_levels.add_child(new_instance, true)
		new_instance.index = _levels.get_child_count() - 1
		new_instance.level_data = level_data
		new_instance.connect("levels_reordered", self, "_on_levels_reordered")
		new_instance.connect("level_updated", self, "_on_level_updated")


func refresh_level_list() -> void:
	_levels_list.value.clear()
	
	var new_list = []
	for child in _levels.get_children():
		new_list.append(child.level_data)
	
	_levels_list.value = new_list

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_levels_reordered() -> void:
	for index in _levels.get_child_count():
		_levels.get_child(index).index = index
		if index == _current_level.value:
			_current_level.value = index
	
	refresh_level_list()


func _on_level_updated(index) -> void:
	_levels_list.value[index] = _levels.get_child(index).level_data
	_levels_list.auto_save()
	if index == _current_level.value:
		_current_level.value = index

### -----------------------------------------------------------------------------------------------
