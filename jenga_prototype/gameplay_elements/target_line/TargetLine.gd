# Write your doc string for this file here
class_name TargetLine
extends Area2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

signal level_completed

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var sensibility: FloatVariable
var scale_factor: FloatVariable

#--- private variables - order: export > normal var > onready -------------------------------------

var _guide_path: NodePathVariable
var _target_line_guide: Control

onready var _timer: Timer = $Timer
onready var _tween: Tween = $Tween
onready var _animator: AnimationPlayer = $AnimationPlayer
onready var _resources: ResourcePreloader = $ResourcePreloader

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	_setup_shared_variables()
	pass


func _process(_delta):
	if _target_line_guide:
		var canvas_transform = get_canvas_transform()
		var canvas_origin = -canvas_transform.origin.y * scale_factor.value
		var guide_position = _target_line_guide.rect_global_position.y * scale_factor.value
		global_position.y = canvas_origin + guide_position

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func has_overlapping_bodies_in_rest() -> bool:
	var bodies = get_overlapping_bodies()
	var is_at_least_one_body_touching_line: = false
	for body in bodies:
		var cup: BaseCup = body.get_parent() as BaseCup
		if cup == null:
			continue
			
		if is_cup_in_rest(cup):
			is_at_least_one_body_touching_line = true
			break
	
	return is_at_least_one_body_touching_line


func is_cup_in_rest(cup: BaseCup) -> bool:
	var is_in_rest: bool = \
			cup.state_machine._state_name == "Dropped" \
			and cup.main_rigid_body.linear_velocity.y > - sensibility.value * scale_factor.value \
			and cup.main_rigid_body.linear_velocity.y < sensibility.value * scale_factor.value
	return is_in_rest

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------


func _setup_shared_variables() -> void:
	sensibility = _resources.get_resource("target_line_sensibility")
	scale_factor = _resources.get_resource("scale_factor")
	_guide_path = _resources.get_resource("target_line_guide")
	_target_line_guide = get_node_or_null(_guide_path.value)
	if not _target_line_guide:
		_guide_path.connect_to(self, "_on_guide_path_value_updated")


func _on_guide_path_value_updated() -> void:
	_target_line_guide = get_node_or_null(_guide_path.value)

### -----------------------------------------------------------------------------------------------
