# Write your doc string for this file here
class_name Shaker
extends Node

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

# How quickly the shaking stops [0, 1].
export var decay: float = 0.8  
# Maximum hor/ver shake in pixels.
export var max_offset: Vector2 = Vector2(100, 75)  
# Maximum rotation in radians (use sparingly).
export var max_roll: float = 0.1  

# Current shake strength.
var trauma: float = 0.0  

#--- private variables - order: export > normal var > onready -------------------------------------
# Trauma exponent. Use [2, 3].
var _trauma_power: int = 2  

var _noise_y = 0

onready var _noise = OpenSimplexNoise.new()

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	randomize()
	_noise.seed = randi()
	_noise.period = 4
	_noise.octaves = 2


func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		_shake()

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _shake():
	var amount = pow(trauma, _trauma_power)
	_noise_y += 1
	if owner is Node2D:
		owner.rotation = max_roll * amount * _noise.get_noise_2d(_noise.seed, _noise_y)
		owner.offset.x = max_offset.x * amount * _noise.get_noise_2d(_noise.seed*2, _noise_y)
		owner.offset.y = max_offset.y * amount * _noise.get_noise_2d(_noise.seed*3, _noise_y)
	elif owner is Control:
		var control = owner as Control
		control.rect_rotation = max_roll * amount * _noise.get_noise_2d(_noise.seed, _noise_y)
		control.rect_pivot_offset.x = max_offset.x * amount \
				* _noise.get_noise_2d(_noise.seed*2, _noise_y)
		control.rect_pivot_offset.y = max_offset.y * amount \
				* _noise.get_noise_2d(_noise.seed*3, _noise_y)

### -----------------------------------------------------------------------------------------------
