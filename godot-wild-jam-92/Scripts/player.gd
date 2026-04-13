class_name Player
extends CharacterBody3D

# MOVEMENT VARS
@export var SPEED : float = 10.0
@export var JUMP_VELOCITY : float = 20
@export var GRAVITY : float = 30
@export var ACCELERATION : float = 15.0
@export var SLOW_DOWN : float = 40.0
@export var PUSH_FORCE : float = 40.0

# CAMERA VARS
@export var CAMERA_ZOOM_RATIO : float = 0.75

# DASH VARS
@export var DASH_SPEED : float = 5.0
@export var DASH_DURATION : float = 0.3
@export var DASH_CD : float = 0.8

# THROW VARS
@export var THROW_SPEED : float = 2
@export var VELOCITY_SCALE : float = 2

var score := 0
var num_jumps := 2
var speed = 0
var can_dash = true
var dashing = false
var target : Fruit = null
var picked_up : Fruit = null


func _ready() -> void:
	add_to_group("player")
	PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY, GRAVITY)
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	## JUMP
	# player cant be hurt in air and can only kill in air
	if Input.is_action_just_pressed("jump") and num_jumps < 2 and not dashing:
		velocity.y = JUMP_VELOCITY
		num_jumps += 1
	elif is_on_floor():
		num_jumps = 0

	
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var relativeDir := Vector3(input_dir.x, 0.0, input_dir.y).rotated(Vector3.UP, $CameraPivot/SpringArm3D.rotation.y)
	
	## MOVE AND DASH
	# handle horizontal movement commands
	if dashing:
		velocity = relativeDir * SPEED * DASH_SPEED
		velocity.y = 0
	elif relativeDir:
		speed = move_toward(speed, SPEED, ACCELERATION * delta)

		velocity.x = relativeDir.x * speed
		velocity.z = relativeDir.z * speed
		
		# turn player towards directionw
		var target_basis = Basis.looking_at(relativeDir.normalized())
		$Pivot.basis = $Pivot.basis.slerp(target_basis, 0.2)
		
		# handle dashing
		if Input.is_action_just_pressed("dash") && can_dash:
			dash()
	elif is_on_floor():
		var slow_down = speed + SLOW_DOWN
		velocity.x = move_toward(velocity.x, 0, slow_down * delta)
		velocity.z = move_toward(velocity.z, 0, slow_down * delta)
	if velocity == Vector3(0, 0, 0):
		speed = 0
	
	## ITEM PICKUP AND DROP
	if Input.is_action_just_pressed("pickup") and picked_up:
		picked_up.is_picked_up = false
		var throw_dir = Vector3(-$Pivot.global_transform.basis.z.x, 0, -$Pivot.global_transform.basis.z.z)
		picked_up.apply_central_impulse((throw_dir * THROW_SPEED * picked_up.mass) + (Vector3(velocity.x, 20, velocity.z) * VELOCITY_SCALE * picked_up.mass))
		picked_up = null
	elif Input.is_action_just_pressed("pickup") and target:
		if target.is_in_spawn:
			signals.danger_increased.emit()
			
		target.is_picked_up = true
		target.is_in_spawn = false
		picked_up = target
	
	
	# TODO: re-add functionality for camera to make character see through when too close
	##if $CameraPivot.position.distance_to($CameraPivot/SpringArm3D/PlayerCamera.position) <= $CameraPivot/SpringArm3D.spring_length * CAMERA_ZOOM_RATIO:
		#for i in range($Pivot/Character/.get_surface_override_material_count()):
			#var new_opacity = ($CameraPivot.position.distance_to($CameraPivot/SpringArm3D/PlayerCamera.position)) / ($CameraPivot/SpringArm3D.spring_length * CAMERA_ZOOM_RATIO)
			#var material = $Pivot/Character/Sphere_001.get_active_material(i).duplicate()
			#material.transparency = true
			#material.albedo_color.a = new_opacity
			#$Pivot/Character/Sphere_001.set_surface_override_material(i, material)
	
	# Handle proper rigid body collisions
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * PUSH_FORCE)
		
	move_and_slide()


# handles player dashing
func dash() -> void:
	can_dash = false
	dashing = true
	
	await get_tree().create_timer(DASH_DURATION).timeout
	dashing = false
	
	await get_tree().create_timer(DASH_CD).timeout
	
	can_dash = true
	

func increase_score(amount) -> void:
	velocity.y = JUMP_VELOCITY
	score += amount
	$"../UI/Score".text = "SCORE: %s" % score


func get_pickup_point() -> Node3D:
	return $Pivot/PickupPoint


func _on_hurtbox_area_entered(area: Area3D) -> void:
	if (area.name == "Hitbox"):
		queue_free()


func _on_pickup_range_area_entered(area: Area3D) -> void:
	if (area.get_parent().is_in_group("fruit")):
		target = area.get_parent()


func _on_pickup_range_area_exited(area: Area3D) -> void:
	if (area.get_parent().is_in_group("fruit")):
		target = null
