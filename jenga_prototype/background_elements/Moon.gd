# Write your doc string for this file here
extends Sprite

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var target_line_nodepath: Resource
export var camera_nodepath: Resource
export var level_current: Resource
export var level_list: Resource
export var reference_height: int = 0

var target_line: Control
var camera: Camera2D
var final_position
var size: Vector2

onready var tween: Tween = $Tween

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	final_position = position
	
	level_current.connect_to(self, "_on_level_current_value_updated")
	
	target_line = get_node_or_null(target_line_nodepath.value)
	if not target_line:
		target_line_nodepath.connect_to(self, "_on_target_line_nodepath_value_updated")
	
	camera = get_node_or_null(camera_nodepath.value)
	if not target_line:
		target_line_nodepath.connect_to(self, "_on_camera_nodepath_value_updated")


func _physics_process(_delta):
	if target_line and camera:
		var canvas_transform = owner.get_canvas_transform()
		var canvas_origin = -canvas_transform.origin.y * camera.zoom.y 
		var guide_position = target_line.rect_global_position.y * camera.zoom.y 
#		scale = camera.zoom
		global_position.y = canvas_origin + guide_position - (reference_height * scale.y / 2)
		global_position.y = clamp(global_position.y, final_position.y, 0)

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_target_line_nodepath_value_updated() -> void:
	target_line = get_node(target_line_nodepath.value)


func _on_camera_nodepath_value_updated() -> void:
	camera = get_node(camera_nodepath.value)


func _on_level_current_value_updated() -> void:
	var attenuation = 1.75 if level_current.value + 1 != level_list.value.size() else 1
	var new_alpha = float(level_current.value + 1) / (level_list.value.size() * attenuation)
	tween.interpolate_property(self, "modulate:a", modulate.a, new_alpha, 
			0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

### -----------------------------------------------------------------------------------------------
