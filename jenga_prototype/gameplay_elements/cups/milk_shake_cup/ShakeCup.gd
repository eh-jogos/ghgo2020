# Write your doc string for this file here
extends BaseCup

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------


func _scale_collision_polygon(polygon: PoolVector2Array) -> PoolVector2Array:
	var converted_scale = Vector2(121, 187) / Vector2(968, 1496)
	for index in polygon.size():
		polygon[index] *= _scale_factor.value * converted_scale
	return polygon


func _handle_scale_factor() -> void:
	var converted_scale = Vector2(121, 187) / Vector2(968, 1496)
	
	skin.scale_factor = _scale_factor.value * converted_scale.x
	if state_machine._state_name == "Dragging":
		skin.scale = Vector2.ONE * _scale_factor.value * converted_scale
	
	cup_detector_polygon.polygon = \
			_scale_collision_polygon(default_measures["cup_detector_polygon"])
	
	for shape in collision_shapes:
		shape.polygon = _scale_collision_polygon(default_measures[shape.name])
	
	for body in rigid_bodies:
		body.mass = 1 * _scale_factor.value * converted_scale.x
	
	for joint in top_rigid_body.get_children():
		if joint is PinJoint2D:
			joint.position = default_measures[joint.name] * _scale_factor.value * converted_scale
	
	for joint in main_rigid_body.get_children():
		if joint is PinJoint2D:
			joint.position = default_measures[joint.name] * _scale_factor.value * converted_scale


func _on_BreakTimer_timeout():
	var converted_scale = Vector2(121, 187) / Vector2(968, 1496)
	var break_area: Area2D = $BreakArea as Area2D
	for body in break_area.get_overlapping_bodies():
		if body.is_in_group("cup"):
			var rigid_body: RigidBody2D = body as RigidBody2D
			rigid_body.angular_velocity = 0
			rigid_body.linear_velocity = Vector2.ZERO
			rigid_body.apply_impulse(Vector2.ZERO, Vector2.UP.rotated(rotation) \
					 * 2000 * _scale_factor.value  * _camera.zoom.y * converted_scale.y)
	queue_free()

### -----------------------------------------------------------------------------------------------


func _on_CupSides_body_entered(body):
	print("OI")
