# Write your doc string for this file here
extends Camera2D

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _resources: ResourcePreloader = $ResourcePreloader
onready var _tween: Tween = $Tween

onready var _scale_factor: FloatVariable = _resources.get_resource("scale_factor")

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	
	zoom = Vector2.ONE * _scale_factor.value
	
	pass

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func update_zoom() -> void:
	var target_zoom = Vector2.ONE * _scale_factor.value
	_tween.interpolate_property(self, "zoom", zoom, target_zoom, \
			0.3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	_tween.start()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
