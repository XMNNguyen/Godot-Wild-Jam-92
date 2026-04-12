class_name Fruit
extends RigidBody3D

## BASE FRUIT CLASS

@export var COLOR : Color = Color.GOLD
@export var SCORE : int = 1
@export var FRUIT_NAME : String = "fruit"
@export var MASS : float = 100.0


func _ready() -> void:
	mass = MASS


func _integrate_forces(state):
	# Example: Reduce velocity by 10% each frame for more drag
	state.linear_velocity *= 0.9


func absorbed() -> void:
	#TODO: insert logic for adding to cauldron score here
	queue_free()
