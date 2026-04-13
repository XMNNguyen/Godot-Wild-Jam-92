class_name FruitSpawner
extends StaticBody3D

@export var FRUIT_TYPES : Array[String] = ["res://Scenes/Fruits/strawberry.tscn"]

var cur_fruit : Fruit = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_fruit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# NOTE: temporary if statement
	if not cur_fruit:
		spawn_fruit()


# helper function to spawn fruit
func spawn_fruit(fruit_type : String = FRUIT_TYPES[randi_range(0, FRUIT_TYPES.size() - 1)]):
	var fruit_instance : Fruit = load(fruit_type).instantiate()
	cur_fruit = fruit_instance
	fruit_instance.is_in_spawn = true
	fruit_instance.position = $SpawnPoint.position 
	add_child(fruit_instance)
