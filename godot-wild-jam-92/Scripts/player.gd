extends CharacterBody3D

@export var SPEED : float = 20.0
@export var JUMP_VELOCITY : float = 4.5
@export var GRAVITY : float = 500
@export var CAMERA_ZOOM_RATIO : float = 0.75
@export var DASH_SPEED : float = 20
@export var ACCELERATION : float = 15.0
@export var SLOW_DOWN : float = 12.0

var score := 0
var num_jumps := 2

var speed = 0

func _ready() -> void:
	#signals.killed_mob.connect(increase_score)
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	# player cant be hurt in air and can only kill in air
	if Input.is_action_just_pressed("jump") and num_jumps < 2:
		$Hitbox.monitoring = true
		$Hitbox.monitorable = true
		$Hurtbox.monitoring = false
		$Hurtbox.monitorable = false
		velocity.y = JUMP_VELOCITY
		num_jumps += 1
	elif is_on_floor():
		$Hitbox.monitoring = false
		$Hitbox.monitorable = false
		$Hurtbox.monitoring = true
		$Hurtbox.monitorable = true
		num_jumps = 0

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var relativeDir := Vector3(input_dir.x, 0.0, input_dir.y).rotated(Vector3.UP, $CameraPivot/SpringArm3D.rotation.y)
	
	print(velocity)
	
	if relativeDir:
		speed = move_toward(speed, SPEED, ACCELERATION * delta)

		velocity.x = relativeDir.x * speed
		velocity.z = relativeDir.z * speed
		
		# turn player towards directionw
		var target_basis = Basis.looking_at(relativeDir.normalized())
		$Pivot.basis = $Pivot.basis.slerp(target_basis, 0.2)
		
		# handle dashing
	else:
		velocity.x = move_toward(velocity.x, 0, SLOW_DOWN * delta)
		velocity.z = move_toward(velocity.z, 0, SLOW_DOWN * delta)
	
	if velocity == Vector3(0, 0, 0):
		speed = 0
	
	##if $CameraPivot.position.distance_to($CameraPivot/SpringArm3D/PlayerCamera.position) <= $CameraPivot/SpringArm3D.spring_length * CAMERA_ZOOM_RATIO:
		#for i in range($Pivot/Character/.get_surface_override_material_count()):
			#var new_opacity = ($CameraPivot.position.distance_to($CameraPivot/SpringArm3D/PlayerCamera.position)) / ($CameraPivot/SpringArm3D.spring_length * CAMERA_ZOOM_RATIO)
			#var material = $Pivot/Character/Sphere_001.get_active_material(i).duplicate()
			#material.transparency = true
			#material.albedo_color.a = new_opacity
			#$Pivot/Character/Sphere_001.set_surface_override_material(i, material)
			
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
