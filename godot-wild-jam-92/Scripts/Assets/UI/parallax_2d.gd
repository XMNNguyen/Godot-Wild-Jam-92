extends TextureRect

@export var parallax_factor : float = 0.2

@onready var camera : Camera3D = $"/root/Main/Player/CameraPivot/SpringArm3D/PlayerCamera"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# move background based on camera movement
	var stick_direction = Input.get_vector("joystick_left", "joystick_right", "joystick_up", "joystick_down")
	
	if stick_direction:
		position.y -= stick_direction.y * parallax_factor
		position.x -= stick_direction.x * parallax_factor
		
	position.y = clamp(position.y, -texture.get_height() , texture.get_height())

func _input(event) -> void:
	# move background based on camera movement
	if event is InputEventMouseMotion:
		position.y -= event.relative.y * parallax_factor
		position.x -= event.relative.x * parallax_factor
