class_name DangerBar
extends TextureProgressBar

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite.frame = int(floor(value / 10))
	
	
	
