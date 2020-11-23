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
	_levels_list.connect_to(self, "_on_levels_list_value_updated")
	_current_level.connect_to(self, "_on_current_level_value_updated")
	
	populate_levels_list()
	
	navigate_to(_current_level.value)

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func populate_levels_list() -> void:
	for child in _levels.get_children():
		_levels.remove_child(child)
		child.queue_free()
	
	for level_data in _levels_list.value:
		_add_level(level_data)


func refresh_level_list() -> void:
	_levels_list.value.clear()
	
	var new_list = []
	for child in _levels.get_children():
		new_list.append(child.level_data)
	
	_levels_list.value = new_list


func navigate_to(level: int) -> void:
	for index in _levels.get_child_count():
		if index == level:
			_levels.get_child(index).expand()
		else:
			_levels.get_child(index).collapse()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _add_level(level_data: LevelData) -> void:
	var new_instance = _resources.get_resource("LevelDataField").instance()
	_levels.add_child(new_instance, true)
	new_instance.index = _levels.get_child_count() - 1
	new_instance.level_data = level_data
	new_instance.connect("levels_reordered", self, "_on_levels_reordered")
	new_instance.connect("level_updated", self, "_on_level_updated")


func _on_levels_reordered() -> void:
	for index in _levels.get_child_count():
		_levels.get_child(index).index = index
		if index == _current_level.value:
			_current_level.value = index
	
	refresh_level_list()


func _on_level_updated(index) -> void:
#	_levels_list.value[index] = _levels.get_child(index).level_data
	_levels_list.auto_save()
	if index == _current_level.value:
		_current_level.value = index


func _on_levels_list_value_updated() -> void:
	populate_levels_list()


func _on_current_level_value_updated() -> void:
	navigate_to(_current_level.value)


func _on_Add_pressed():
	var level_dada: = LevelData.new()
	_levels_list.append(level_dada)
	populate_levels_list()

### -----------------------------------------------------------------------------------------------
