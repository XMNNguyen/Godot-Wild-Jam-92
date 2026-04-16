extends Camera3D

@export var sensitivity : float = 0.002
@export var tilt_limit = deg_to_rad(75)
@export var shake_strength:float = 5
@export var fade: float = 5

var _cur_shake_strength = 0

@onready var player = $"../../.."

func _ready() -> void:
	signals.shake_camera.connect(_on_shake)
	pass


func _process(delta: float) -> void:
	if _cur_shake_strength > 0:
		_cur_shake_strength = lerpf(_cur_shake_strength, 0, fade * delta)
		
		h_offset = randf_range(-_cur_shake_strength, _cur_shake_strength)
		v_offset = randf_range(-_cur_shake_strength, _cur_shake_strength)
	
	var stick_direction = Input.get_vector("joystick_left", "joystick_right", "joystick_up", "joystick_down")
	
	if stick_direction:
		$"..".rotation.x -= stick_direction.y * sensitivity
		$"..".rotation.y -= stick_direction.x * sensitivity
		$"..".rotation.x = clampf($"..".rotation.x, -tilt_limit, tilt_limit)
		
func _input(event) -> void:
	if event is InputEventMouseMotion:
		#rotation.y -= event.relative.x * sensitivity
		$"..".rotation.x -= event.relative.y * sensitivity
		$"..".rotation.y -= event.relative.x * sensitivity
		$"..".rotation.x = clampf($"..".rotation.x, -tilt_limit, tilt_limit)


func _on_shake() -> void:
	_cur_shake_strength = shake_strength
