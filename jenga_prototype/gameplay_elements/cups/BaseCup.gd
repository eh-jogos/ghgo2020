# Write your doc string for this file here
class_name BaseCup
extends Node2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const MAIN_MOUSE_GUIDE_PATH = \
		"res://jenga_prototype/shared_variables/nodepath_main_mouse_guide.tres"

#--- public variables - order: export > normal var > onready --------------------------------------

var is_active: = false setget _set_is_active
var is_over_other_cups: = false setget _set_is_over_other_cups

var mouse_guide: Sprite = null

var default_measures: = {}

onready var resources: ResourcePreloader = $ResourcePreloader
onready var state_machine: StateMachine = $CupStateMachine
onready var skin: CupSkin = $Skin
onready var tween: Tween = $Tween
onready var sfx_hits: SfxLibrary = $SfxHit
onready var sfx_table: SfxLibrary = $SfxTable
onready var sfx_fit: SfxLibrary = $SfxFit

onready var cup_detector: Area2D = $CupDetector
onready var cup_detector_polygon: CollisionPolygon2D = $CupDetector/CollisionPolygon2D
onready var main_rigid_body: RigidBody2D = $CupSides
onready var top_rigid_body: RigidBody2D = $CupTop
onready var rigid_bodies: Array = [
	main_rigid_body,
	top_rigid_body,
]
onready var collision_shapes: Array = [
	$CupSides/SideLeft,
	$CupSides/SideRight,
	$CupSides/Bottom,
	$CupTop/Top,
	$SfxHitDetector/SfxCollision,
	$SfxFitDetector/SfxFitArea,
	$BreakArea/BreakPolygon,
]


#--- private variables - order: export > normal var > onready -------------------------------------

var _main_mouse_reference: NodePathVariable
var _camera: Camera2D

onready var _scale_factor: FloatVariable = resources.get_resource("float_scale_factor")
onready var _camera_path: NodePathVariable = resources.get_resource("nodepath_main_camera")

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	eh_Utility.set_node_as_toplevel(main_rigid_body, true)
	
	_main_mouse_reference = load(MAIN_MOUSE_GUIDE_PATH) as NodePathVariable
	_update_mouse_guide()
	_main_mouse_reference.connect_to(self, "_on_main_mouse_reference_value_changed")
	
	if _camera_path.value != null:
		_camera = get_node(_camera_path.value)
	_camera_path.connect_to(self, "_on_camera_path_value_updated")
	
	default_measures["cup_detector_polygon"] = cup_detector_polygon.polygon
	
	for shape in collision_shapes:
		default_measures[shape.name] = shape.polygon
	
	for joint in top_rigid_body.get_children():
		if joint is PinJoint2D:
			default_measures[joint.name] = joint.position
	
	for joint in main_rigid_body.get_children():
		if joint is PinJoint2D:
			default_measures[joint.name] = joint.position
	
	_handle_scale_factor()


func _physics_process(delta):
	global_position = main_rigid_body.global_position
	rotation_degrees = main_rigid_body.rotation_degrees
	
	if cup_detector:
		var overlapping_cups: Array = cup_detector.get_overlapping_areas()
		var overlapping_ground: Array = cup_detector.get_overlapping_bodies()
		
		if overlapping_cups.empty() and overlapping_ground.empty():
			self.is_over_other_cups = false
		else:
			self.is_over_other_cups = true

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func set_collisons(to_active: bool) -> void:
	if to_active:
		for shape in collision_shapes:
			shape.disabled = false
	else:
		for shape in collision_shapes:
			shape.disabled = true

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _scale_collision_polygon(polygon: PoolVector2Array) -> PoolVector2Array:
	for index in polygon.size():
		polygon[index] *= _scale_factor.value
	return polygon


func _handle_scale_factor() -> void:
	skin.scale_factor = _scale_factor.value
	if state_machine._state_name == "Dragging":
		skin.scale = Vector2.ONE * _scale_factor.value
	
	cup_detector_polygon.polygon = \
			_scale_collision_polygon(default_measures["cup_detector_polygon"])
	
	for shape in collision_shapes:
		shape.polygon = _scale_collision_polygon(default_measures[shape.name])
	
	for body in rigid_bodies:
		body.mass = 1 * _scale_factor.value
	
	for joint in top_rigid_body.get_children():
		if joint is PinJoint2D:
			joint.position = default_measures[joint.name] * _scale_factor.value
	
	for joint in main_rigid_body.get_children():
		if joint is PinJoint2D:
			joint.position = default_measures[joint.name] * _scale_factor.value


func _set_is_active(value: bool) -> void:
	is_active = value
	
	if not is_inside_tree():
		yield(self, "ready")
	
	if is_active:
		_set_physics_mode()
	else:
		_set_drag_mode()


func _set_physics_mode() -> void:
	set_collisons(true)
	
	for body in rigid_bodies:
		body.mode = RigidBody2D.MODE_RIGID
	
	modulate = Color.white


func _set_drag_mode() -> void:
	set_collisons(false)
	
	for body in rigid_bodies:
		body.mode = RigidBody2D.MODE_STATIC


func _update_mouse_guide() -> void:
	mouse_guide = get_node_or_null(_main_mouse_reference.value)


func _on_main_mouse_reference_value_changed() -> void:
	_update_mouse_guide()


func _on_camera_path_value_updated() -> void:
	_camera = get_node_or_null(_camera_path.value)


func _set_is_over_other_cups(value: bool) -> void:
	is_over_other_cups = value
	if is_over_other_cups:
		modulate = Color.red
	else:
		modulate = Color.white


func _on_SfxHitDetector_body_entered(body) -> void:
	if body == main_rigid_body or body == top_rigid_body:
		return
	
	if body.is_in_group("cup"):
		sfx_hits.play()
	else:
		sfx_table.play()


func _on_SfxFitDetector_body_entered(body):
	if body.is_in_group("cup"):
		sfx_fit.play()


func _on_BreakArea_body_exited(body):
	if body.is_in_group("cup"):
		for joint in main_rigid_body.get_children():
			if joint is PinJoint2D:
				joint.node_a = NodePath()
				joint.node_b = NodePath()


func _on_BreakArea_body_entered(body):
	if body.is_in_group("cup"):
		for joint in main_rigid_body.get_children():
			if joint is PinJoint2D:
				joint.node_a = main_rigid_body.get_path()
				joint.node_b = body.get_path()

### -----------------------------------------------------------------------------------------------
