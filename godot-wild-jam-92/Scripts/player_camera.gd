extends Camera3D

@export var sensitivity : float = 0.002
@export var tilt_limit = deg_to_rad(75)

@onready var player = $"../../.."

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event) -> void:
	if event is InputEventMouseMotion:
		#rotation.y -= event.relative.x * sensitivity
		$"..".rotation.x -= event.relative.y * sensitivity
		$"..".rotation.y -= event.relative.x * sensitivity
		$"..".rotation.x = clampf($"..".rotation.x, -tilt_limit, tilt_limit)
