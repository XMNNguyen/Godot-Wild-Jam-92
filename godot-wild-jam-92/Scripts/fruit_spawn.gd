class_name FruitSpawner
extends StaticBody3D

@export var FRUIT_TYPES : Array[String] = ["res://Scenes/Fruits/strawberry.tscn"]
@export var SPAWN_TIME : float = 1

var cd_timer : Timer = null

var cur_fruit : Fruit = null
var on_cd : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_fruit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# NOTE: temporary if statement
	if not cur_fruit and not on_cd:
		set_cd()
	elif not cur_fruit and not on_cd and cd_timer and cd_timer.is_stopped():
		on_cd = false
		spawn_fruit()


# helper function to spawn fruit
func spawn_fruit(fruit_type : String = FRUIT_TYPES[randi_range(0, FRUIT_TYPES.size() - 1)]):
	var fruit_instance : Fruit = load(fruit_type).instantiate()
	cur_fruit = fruit_instance
	fruit_instance.scale = Vector3(0.75, 0.75, 0.75)
	fruit_instance.is_in_spawn = true
	fruit_instance.position = $SpawnPoint.position 
	add_child(fruit_instance)


func set_cd() -> void:
	on_cd = true
	cd_timer = Timer.new()
	cd_timer.one_shot = true
	add_child(cd_timer)
	cd_timer.start(SPAWN_TIME)
