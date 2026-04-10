extends CharacterBody3D

@export var SPEED : float = 5.0
@export var JUMP_VELOCITY : float = 4.5
@export var GRAVITY : float = 500
@export var CAMERA_ZOOM_RATIO : float = 0.75

var score = 0

func _ready() -> void:
	signals.killed_mob.connect(increase_score)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	# player cant be hurt in air and can only kill in air
	if Input.is_action_just_pressed("jump") and is_on_floor():
		$Hitbox.monitoring = true
		$Hitbox.monitorable = true
		$Hurtbox.monitoring = false
		$Hurtbox.monitorable = false
		velocity.y = JUMP_VELOCITY
	elif is_on_floor():
		$Hitbox.monitoring = false
		$Hitbox.monitorable = false
		$Hurtbox.monitoring = true
		$Hurtbox.monitorable = true

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var relativeDir := Vector3(input_dir.x, 0.0, input_dir.y).rotated(Vector3.UP, $CameraPivot/SpringArm3D.rotation.y)
	
	if relativeDir:
		velocity.x = relativeDir.x * SPEED
		velocity.z = relativeDir.z * SPEED
		
		# turn player towards direction
		var target_basis = Basis.looking_at(relativeDir.normalized())
		$Pivot.basis = $Pivot.basis.slerp(target_basis, 0.2)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	print($CameraPivot.position.distance_to($CameraPivot/SpringArm3D/PlayerCamera.position))
	print($CameraPivot/SpringArm3D.spring_length * CAMERA_ZOOM_RATIO)
	if $CameraPivot.position.distance_to($CameraPivot/SpringArm3D/PlayerCamera.position) <= $CameraPivot/SpringArm3D.spring_length * CAMERA_ZOOM_RATIO:
		for i in range($Pivot/Character/Sphere_001.get_surface_override_material_count()):
			var new_opacity = ($CameraPivot.position.distance_to($CameraPivot/SpringArm3D/PlayerCamera.position)) / ($CameraPivot/SpringArm3D.spring_length * CAMERA_ZOOM_RATIO)
			var material = $Pivot/Character/Sphere_001.get_active_material(i).duplicate()
			material.transparency = true
			material.albedo_color.a = new_opacity
			$Pivot/Character/Sphere_001.set_surface_override_material(i, material)
			
	move_and_slide()

func increase_score(amount) -> void:
	velocity.y = JUMP_VELOCITY
	score += amount
	$"../UI/Score".text = "SCORE: %s" % score


func _on_hurtbox_area_entered(area: Area3D) -> void:
	if (area.name == "Hitbox"):
		$"../SpawnTimer".stop()
		queue_free()
		$"../UI/RetryButton".show()
