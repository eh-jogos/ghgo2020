# Write your doc string for this file here
extends State

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var hook_max_speed = 1600.0
export var arrive_push: = 500.0

var target_global_position: = Vector2(INF, INF)
var velocity: = Vector2.ZERO

onready var player: Player = owner as Player

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func unhandled_input(event: InputEvent) -> void:
	pass


func physics_process(delta: float) -> void:
	velocity = Steering.arrive_to(
		velocity,
		player.global_position,
		target_global_position,
		hook_max_speed
	)
	velocity = velocity if velocity.length() > arrive_push else velocity.normalized() * arrive_push
	velocity = player.move_and_slide(velocity, player.FLOOR_NORMAL)
	
	var vector_to_target: Vector2 = target_global_position - player.global_position
	var distance: = vector_to_target.length()
	var distance_traveled_in_one_frame = velocity.length() * delta
	
	if distance < distance_traveled_in_one_frame or not Input.is_action_pressed("hook"):
		velocity = velocity.normalized() * arrive_push
		_state_machine.transition_to("Move/Air", {"velocity": velocity})


func enter(msg: Dictionary = {}) -> void:
	match msg:
		{"target_global_position": var tgp, "velocity": var v}:
			target_global_position = tgp
			velocity = v
	
	player.hookshot.connect("hooked_onto_target", self, "_on_hook_hooked_onto_target")


func exit() -> void:
	target_global_position = Vector2(INF, INF)
	velocity = Vector2.ZERO
	
	player.hookshot.disconnect("hooked_onto_target", self, "_on_hook_hooked_onto_target")

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_hook_hooked_onto_target(p_target_global_position: Vector2) -> void:
	target_global_position = p_target_global_position

### -----------------------------------------------------------------------------------------------
