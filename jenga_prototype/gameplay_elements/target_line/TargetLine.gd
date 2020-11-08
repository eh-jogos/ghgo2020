# Write your doc string for this file here
extends Area2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

signal level_completed

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _timer: Timer = $Timer
onready var _tween: Tween = $Tween

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	modulate.a = 0.3

func _physics_process(_delta):
	var bodies = get_overlapping_bodies()
	var is_at_least_one_body_touching_line: = false
	for body in bodies:
		var cup: BaseCup = body.get_parent() as BaseCup
		if cup == null:
			continue
			
		if cup.state_machine._state_name == "Dropped"\
				and cup.main_rigid_body.linear_velocity.y > -5 \
				and cup.main_rigid_body.linear_velocity.y < 5 : 
			is_at_least_one_body_touching_line = true
		else:
			print(cup.state_machine._state_name)
	
	if is_at_least_one_body_touching_line:
		if _timer.is_stopped():
			_tween.repeat = true
			_tween.interpolate_property(self, "modulate:a", 0.3, 0.8, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
			_tween.interpolate_property(self, "modulate:a", 0.8, 0.3, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
			_tween.start()
			
			_timer.start()
	else:
		_tween.remove_all()
		_tween.repeat = false
		_tween.interpolate_property(self, "modulate:a", modulate.a, 0.3, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
		_tween.start()
		
		_timer.stop()
	
	

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_Timer_timeout():
	set_physics_process(false)
	_tween.remove_all()
	_tween.repeat = false
	_tween.interpolate_property(self, "modulate:a", modulate.a, 0.3, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	_tween.interpolate_property(self, "position:y", position.y, position.y - 100,
			0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	_tween.start()
	yield(_tween, "tween_all_completed")
	emit_signal("level_completed")
	set_physics_process(true)

### -----------------------------------------------------------------------------------------------
