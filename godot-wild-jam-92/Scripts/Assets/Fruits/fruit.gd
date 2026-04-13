class_name Fruit
extends RigidBody3D

## BASE FRUIT CLASS

@export var COLOR : Color = Color.GOLD
@export var SCORE : int = 1
@export var FRUIT_NAME : String = "fruit"
@export var MASS : float = 1000.0

@onready var player : Player = get_tree().get_first_node_in_group("player")

var is_picked_up : bool = false
var is_in_spawn : bool = false

func _ready() -> void:
	mass = MASS
	add_to_group("fruit")


func _process(delta: float) -> void:
	# handles if fruit is still in its spawnpoint
	if is_in_spawn:
		$CollisionShape3D.disabled = true
		gravity_scale = 0
		rotate(Vector3(1,0,1), 1)
	else:
		$CollisionShape3D.disabled = false
		gravity_scale = 1

	# handles when fruit is picked up
	if is_picked_up:
		$CollisionShape3D.disabled = true 
		is_in_spawn = false
		global_position = lerp(global_position, player.global_position, 1.0)
	else:
		$CollisionShape3D.disabled = false 
