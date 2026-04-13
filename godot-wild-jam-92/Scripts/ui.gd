class_name Ui
extends Control

@export var MAX_FUEL : int = 100

@onready var player = %Player

var fuel : int = MAX_FUEL

# TIMERS
var tick_time : float = 5.0
var tick_timer : Timer = null
var spawn_time : float = 10.0
var spawn_timer : Timer = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	signals.fruit_collected.connect(add_fuel)
	set_tick()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tick_timer.is_stopped():
		fuel -= 1
		set_tick()
	
	if fuel <= 0:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")


func set_tick() -> void:
	tick_timer = Timer.new()
	tick_timer.one_shot = true
	add_child(tick_timer)
	tick_timer.start(tick_time)


func add_fuel(fuel_amount : float) -> void:
	fuel = min(fuel + fuel_amount, MAX_FUEL)
