class_name Fruit
extends RigidBody3D

## BASE FRUIT CLASS

@export var COLOR : Color = Color.GOLD
@export var SCORE : int = 1
@export var FRUIT_NAME : String = "fruit"
@export var MASS : float = 20.0


func _ready() -> void:
	mass = MASS


func absorbed() -> void:
	#TODO: insert logic for adding to cauldron score here
	queue_free()
