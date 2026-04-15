class_name Ui
extends Control

@export var MAX_FUEL : int = 100
@export var MAX_DANGER : int = 50
@export var MAX_LIFE : int = 3
@export var SPAWN_DISTANCE : float = 15

@onready var player = %Player
@onready var hearts = $Heart_Bar/Hearts
@onready var danger_bar : TextureProgressBar = $DangerBar
@onready var fuel_bar : TextureProgressBar = $FuelBar
@onready var enemy_path = "res://Scenes/enemy.tscn"

var fuel : int = MAX_FUEL
var danger_level : int = 50
var player_life : int = MAX_LIFE

# TIMERS
var tick_time : float = 5.0
var tick_timer : Timer = null
var spawn_time : float = 10.0
var spawn_timer : Timer = null
var recovery_time_left : float = 10
var recovery_time_left_timer : Timer = null
var recovery_time : float = recovery_time_left / MAX_LIFE
var recovery_timer : Timer = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	signals.player_hit.connect(player_hit)
	signals.danger_increased.connect(increase_danger)
	signals.fruit_collected.connect(add_fuel)
	fuel_bar.value = fuel
	set_tick()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if recovery_time_left_timer and not recovery_time_left_timer.is_stopped():
		print("RESPAWN:\n" + str(floor(recovery_time_left_timer.time_left)))
		$TimerDisplay.text = "RESPAWN:\n" + str(int(ceil(recovery_time_left_timer.time_left)))
	
	if tick_timer and tick_timer.is_stopped():
		fuel -= 1
		fuel_bar.value = fuel
		set_tick()
	
	if (spawn_timer 
		and spawn_timer.is_stopped() 
		and (not recovery_time_left_timer or recovery_time_left_timer and recovery_time_left_timer.is_stopped())):
		var num_enemies = max(1, danger_level / 5)
		spawn_enemies(num_enemies)
	
	if player.recovering and recovery_timer and recovery_timer.is_stopped():
		player_life += 1
		hearts.gain_health()
		
		if player_life >= MAX_LIFE:
			player.recovering = false
			$TimerDisplay.visible = false
		else:
			set_recovery_timer()
	
	if fuel <= 0:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")


func set_tick() -> void:
	tick_timer = Timer.new()
	tick_timer.one_shot = true
	add_child(tick_timer)
	tick_timer.start(tick_time)


func add_fuel(fuel_amount : float) -> void:
	fuel = min(fuel + fuel_amount, MAX_FUEL)
	fuel_bar.value = fuel


func increase_danger() -> void:
	danger_level += 1
	var num_enemies = max(1, danger_level / 5)
	danger_bar.value = danger_level
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
	hearts.lose_health()
	if player_life <= 0:
		if player.picked_up:
			player.picked_up.is_picked_up = false
		player.target = null
		player.picked_up = null
		player.position = $"../Cauldron".global_position + Vector3(0, 10, 0)
		player.recovering = true
		set_recovery_timer()
		set_recovery_time_left()
		


func set_recovery_timer() -> void:
	recovery_timer = Timer.new()
	recovery_timer.one_shot = true
	add_child(recovery_timer)
	recovery_timer.start(recovery_time)


func set_recovery_time_left() -> void:
	recovery_time_left_timer = Timer.new()
	recovery_time_left_timer.one_shot = true
	add_child(recovery_time_left_timer)
	recovery_time_left_timer.start(recovery_time_left)
	$TimerDisplay.visible = true
