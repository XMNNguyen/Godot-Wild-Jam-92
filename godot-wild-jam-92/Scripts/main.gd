class_name Main
extends Node

const WORLD_RADIUS : float = 148

var slowdown_timer : Timer = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	signals.slow_time.connect(slow_time)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func slow_time(time : float) -> void:
	# set the time scale
	Engine.time_scale = 0.002
	
	# create the pause timer and wait for timer to expire, igoring the time scale
	await get_tree().create_timer(0.3, true, false, true).timeout
	
	# set the time back to normal
	Engine.time_scale = 1
