# Write your doc string for this file here
extends Area2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------
var target: HookTarget setget _set_target

onready var ray_cast: RayCast2D = $RayCast2D

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _hooking_hint: Position2D = $HookingHint

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	ray_cast.set_as_toplevel(true)


func _physics_process(delta: float) -> void:
	var tentative_target = _find_best_target()
	if target != tentative_target:
		self.target = _find_best_target()

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func has_target() -> bool:
	return target != null

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _find_best_target() -> HookTarget:
	var closest_taget: HookTarget = null
	var targets: = get_overlapping_areas()
	for target in targets:
		if not target is HookTarget:
			continue
		
		if not target.is_active:
			continue
		
		ray_cast.global_position = global_position
		ray_cast.cast_to = target.global_position - ray_cast.global_position
		if ray_cast.is_colliding():
			continue
		
		closest_taget = target
		break
	
	return closest_taget


func _set_target(value: HookTarget) -> void:
	target = value
	_hooking_hint.visible = has_target()
	_hooking_hint.global_position = target.global_position if target else _hooking_hint.global_position


### -----------------------------------------------------------------------------------------------




