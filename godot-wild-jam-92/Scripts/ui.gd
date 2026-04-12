class_name Ui
extends Control

@export var MAX_FUEL : int = 100

var fuel : int = MAX_FUEL
var tick_time : float = 1.0
var tick_timer : Timer = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	signals.fruit_collected.connect(add_fuel)
	set_tick()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tick_timer.is_stopped():
		fuel -= 1
		set_tick()
		print(fuel)


func set_tick() -> void:
	tick_timer = Timer.new()
	tick_timer.one_shot = true
	add_child(tick_timer)
	tick_timer.start(tick_time)


func add_fuel(fuel_amount : float) -> void:
	fuel = min(fuel + fuel_amount, MAX_FUEL)
	print(fuel)
