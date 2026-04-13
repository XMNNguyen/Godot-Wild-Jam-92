class_name Enemy
extends CharacterBody3D


@export var SPEED : float = 5.0
@export var TIME_TO_LIVE : float = 5

@onready var player : Player = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	$TimeToLive.start(TIME_TO_LIVE)


func _physics_process(delta: float) -> void:
	move(delta)
	move_and_slide()


func move(delta: float):
	var direction = position.direction_to(player.position).normalized()
	
	var target_basis = Basis.looking_at(direction.normalized())
	$Pivot.basis = $Pivot.basis.slerp(target_basis, 0.2)
	velocity = direction * SPEED


func _on_time_to_live_timeout() -> void:
	queue_free()
