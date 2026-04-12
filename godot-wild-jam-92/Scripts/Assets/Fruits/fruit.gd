class_name Fruit
extends RigidBody3D

## BASE FRUIT CLASS

@export var COLOR : Color = Color.GOLD
@export var SCORE : int = 1
@export var FRUIT_NAME : String = "fruit"
@export var MASS : float = 100.0

var is_picked_up : bool = false

func _ready() -> void:
	mass = MASS
	add_to_group("fruit")


func _process(delta: float) -> void:
	if is_picked_up:
		$CollisionShape3D.disabled = true 
		global_position = lerp(global_position, %Player/Pivot/PickupPoint.global_position, 1.0)
	else:
		$CollisionShape3D.disabled = false 


func _integrate_forces(state):
	# add more drag to object
	state.linear_velocity *= 0.9


func absorbed() -> void:
	#TODO: insert logic for adding to cauldron score here
	queue_free()
