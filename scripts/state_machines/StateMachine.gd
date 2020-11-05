# Based this from GDQuest Platform Character Movement Course
# Generic State Machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
class_name StateMachine
extends Node

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var initial_state: = NodePath()
onready var state: State = get_node(initial_state) setget _set_state

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _state_name: = state.name

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _init() -> void:
	add_to_group("state_machine")


func _ready() -> void:
	yield(owner, "ready")
	state.enter()


func _unhandled_input(event: InputEvent) -> void:
	state.unhandled_input(event)


func _physics_process(delta: float) -> void:
	state.physics_process(delta)

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func transition_to(target_state_path: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		return

	var target_state: = get_node(target_state_path)

	state.exit()
	self.state = target_state
	state.enter(msg)

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_state(value: State) -> void:
	state = value
	_state_name = state.name

### -----------------------------------------------------------------------------------------------
