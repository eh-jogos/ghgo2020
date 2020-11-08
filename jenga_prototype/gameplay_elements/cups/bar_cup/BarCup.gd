# Write your doc string for this file here
extends RigidBody2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var is_dragging: = false
var drunk_factor = 0.5
var target_position
var follow_velocity: = Vector2.ZERO

var is_colliding_with_top: = false

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _collision_shapes: Array = [$CollisionPolygon2D, $CollisionPolygon2D2, $CollisionShape2D]
onready var _mouse_guide: Sprite = $MouseGuide
onready var _tween: Tween = $Tween

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	randomize()


func _unhandled_input(event: InputEvent):
	if is_dragging:
		if event.is_action_pressed("hook"):
			is_dragging = false
			for _shape in _collision_shapes:
				_shape.disabled = false
			_tween.remove_all()
			linear_velocity = Vector2.ZERO
			angular_velocity = 0
			applied_force = Vector2.ZERO
			mode = RigidBody2D.MODE_RIGID
			modulate = Color.white
			get_tree().set_input_as_handled()
		if event.is_action_pressed("jenga_rotate_clockwise"):
			rotation_degrees += 6
		elif event.is_action_pressed("jenga_rotate_anti_clockwise"):
			rotation_degrees -= 6


func _physics_process(delta: float):
	if not is_dragging:
		return
	
	follow_mouse(delta)

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func follow_mouse(delta: float) -> void:
	#print("my position: %s | guide position: %s"%[global_position, _mouse_guide.global_position])
	global_position = _mouse_guide.global_position

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_GrabArea_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if not is_dragging and event.is_action_pressed("hook"):
		is_dragging = true
		for _shape in _collision_shapes:
			_shape.disabled = true
		mode = RigidBody2D.MODE_KINEMATIC
		modulate = Color.red

### -----------------------------------------------------------------------------------------------


func _on_CupTop_area_entered(area):
	var cup = area.owner.rigid_body as RigidBody2D
	print("%s | %s"%[cup.name, cup.linear_velocity.y])
	if cup.linear_velocity.y > 1:
		cup.is_colliding_with_top = true
		cup.applied_force = (Vector2.UP * 980)
		cup.linear_velocity = Vector2.ZERO
	pass


func _on_CupTop_area_exited(area):
	var cup = area.owner.rigid_body as RigidBody2D
	cup.is_colliding_with_top = false
	applied_force.y = 0
