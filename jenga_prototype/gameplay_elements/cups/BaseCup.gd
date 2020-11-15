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

var mouse_guide: Sprite = null

onready var resources: ResourcePreloader = $ResourcePreloader
onready var state_machine: StateMachine = $CupStateMachine
onready var skin: CupSkin = $Skin
onready var tween: Tween = $Tween
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
	$CupTop/Top
]


#--- private variables - order: export > normal var > onready -------------------------------------

var _main_mouse_reference: NodePathVariable

onready var _scale_factor: FloatVariable = resources.get_resource("float_scale_factor")

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	eh_Utility.set_node_as_toplevel(main_rigid_body, true)
	
	_main_mouse_reference = load(MAIN_MOUSE_GUIDE_PATH) as NodePathVariable
	_update_mouse_guide()
	_main_mouse_reference.connect_to(self, "_on_main_mouse_reference_value_changed")
	
	_handle_scale_factor()


func _physics_process(delta):
	global_position = main_rigid_body.global_position
	rotation_degrees = main_rigid_body.rotation_degrees

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

func _handle_scale_factor() -> void:
	skin.scale_factor = _scale_factor.value
	
	for shape in collision_shapes:
		var scaled_polygon: PoolVector2Array = shape.polygon
		for index in scaled_polygon.size():
			scaled_polygon[index] *= _scale_factor.value
		shape.polygon = scaled_polygon
	
	for child in top_rigid_body.get_children():
		if child is CollisionPolygon2D:
			continue
		
		child.position *= _scale_factor.value


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
	
	modulate = Color.red


func _update_mouse_guide() -> void:
	if _main_mouse_reference.value != null:
		mouse_guide = get_node(_main_mouse_reference.value)
	else:
		mouse_guide = null


func _on_main_mouse_reference_value_changed() -> void:
	_update_mouse_guide()

### -----------------------------------------------------------------------------------------------
