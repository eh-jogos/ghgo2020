# Write your doc string for this file here
extends Node2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var scale_factor = 1.0

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _resource_preloader: ResourcePreloader = $ResourcePreloader
onready var _cup_spawn_point = $HUDLayer/HUD/SpawnCups/SpawnPivot/CupSpawnPoint
onready var _cups_layer: Node2D = $Cups

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	
	pass

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func add_cup() -> void:
	var new_cup: BaseCup = _resource_preloader.get_resource("cup").instance()
	new_cup.scale *= scale_factor
	new_cup.global_position = _cup_spawn_point.global_position
	_cups_layer.add_child(new_cup, true)


func clear_cups() -> void:
	for cup in _cups_layer.get_children():
		_cups_layer.remove_child(cup)
		cup.queue_free()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_SpawnCups_pressed():
	add_cup()


func _on_TargetLine_level_completed():
	clear_cups()

### -----------------------------------------------------------------------------------------------


