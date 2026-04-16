extends Parallax2D

@export var parallax_factor_x : float = 0.2
@export var parallax_factor_y : float = 1.0

@onready var camera : Camera3D = $"/root/Main/Player/CameraPivot/SpringArm3D/PlayerCamera"
@onready var sprite : Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# move background based on camera movement
	print(position)
	var stick_direction = Input.get_vector("joystick_left", "joystick_right", "joystick_up", "joystick_down")
	
	if stick_direction:
		position.y -= stick_direction.y * parallax_factor_y
		position.x -= stick_direction.x * parallax_factor_x
		
	position.y = clamp(position.y, -sprite.texture.get_height()/3.7, sprite.texture.get_height()/3)

func _input(event) -> void:
	# move background based on camera movement
	if event is InputEventMouseMotion:
		position.y -= event.relative.y * parallax_factor_y
		position.x -= event.relative.x * parallax_factor_x
