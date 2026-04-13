class_name Ui
extends Control

@export var MAX_FUEL : int = 100
@export var MAX_DANGER : int = 50
@export var MAX_LIFE : int = 3
@export var SPAWN_DISTANCE : float = 15

@onready var player = %Player
@onready var enemy_path = "res://Scenes/enemy.tscn"

var fuel : int = MAX_FUEL
var danger_level : int = 1
var player_life : int = MAX_LIFE

# TIMERS
var tick_time : float = 5.0
var tick_timer : Timer = null
var spawn_time : float = 10.0
var spawn_timer : Timer = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	signals.player_hit.connect(player_hit)
	signals.danger_increased.connect(increase_danger)
	signals.fruit_collected.connect(add_fuel)
	set_tick()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tick_timer and tick_timer.is_stopped():
		fuel -= 1
		set_tick()
	
	if spawn_timer and spawn_timer.is_stopped():
		var num_enemies = max(1, danger_level / 5)
		spawn_enemies(num_enemies)
	
	if fuel <= 0:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")


func set_tick() -> void:
	tick_timer = Timer.new()
	tick_timer.one_shot = true
	add_child(tick_timer)
	tick_timer.start(tick_time)


func add_fuel(fuel_amount : float) -> void:
	fuel = min(fuel + fuel_amount, MAX_FUEL)


func increase_danger() -> void:
	danger_level += 1
	var num_enemies = max(1, danger_level / 5)
	spawn_enemies(num_enemies)


func spawn_enemies(amount : int = 1) -> void:
	for i in range(amount):
		var direction = Vector3(randf_range(-1, 1), 
								randf_range(0, 1), 
								randf_range(-1, 1)).normalized()
		
		var enemy_instance = load(enemy_path).instantiate()
		var spawn_distance = randf_range(SPAWN_DISTANCE, SPAWN_DISTANCE + (danger_level / 2))
		enemy_instance.global_position = player.position + (direction * SPAWN_DISTANCE)
		
		get_tree().current_scene.add_child(enemy_instance)
	
	set_spawn_timer()


func set_spawn_timer() -> void:
	spawn_timer = Timer.new()
	spawn_timer.one_shot = true
	add_child(spawn_timer)
	spawn_timer.start(spawn_time - floor(danger_level / 2))


func player_hit() -> void:
	player_life -= 1
	print(player_life)
	if player_life <= 0:
		player.position = $"../Cauldron".global_position + Vector3(0, 10, 0)
