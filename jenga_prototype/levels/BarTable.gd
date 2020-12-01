# Write your doc string for this file here
extends StaticBody2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var level_to_disappear: int = 4
export var current_level: Resource
export var nodepath_table_guide: Resource
export var nodepath_camera: Resource

var camera: Camera2D
var table_guide: Control

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _collision: CollisionShape2D = $CollisionShape2D

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	camera = get_node_or_null(nodepath_camera.value)
	if not camera:
		nodepath_camera.connect_to(self, "_on_nodepath_camera_value_updated")
	
	current_level = current_level as IntVariable
	if current_level != null:
		set_table(current_level.value)
		current_level.connect_to(self, "_on_current_level_value_updated")


func _physics_process(_delta) -> void:
	if not table_guide:
		table_guide = get_node_or_null(nodepath_table_guide.value)
	else:
		global_position = _convert_from_hud_position(table_guide.rect_global_position)

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func set_table(level_number: int) -> void:
	if level_number >= level_to_disappear:
		hide()
		_collision.disabled = true
	else:
		show()
		_collision.disabled = false

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _convert_from_hud_position(hud_position: Vector2) -> Vector2:
	var canvas_transform = get_canvas_transform()
	var canvas_origin = -canvas_transform.origin * camera.zoom
	var reference_position = hud_position * camera.zoom
	var final_position = canvas_origin + reference_position
	
	return final_position


func _on_current_level_value_updated() -> void:
	set_table(current_level.value)


func _on_nodepath_camera_value_updated() -> void:
	camera = get_node(nodepath_camera.value)

### -----------------------------------------------------------------------------------------------
