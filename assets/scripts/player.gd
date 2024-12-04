extends CharacterBody3D

const SPEED = 80.0
const JUMP_VELOCITY = 4.5
const accel = 1.5

var projectile = load("res://assets/scenes/projectile.tscn")

func _physics_process(delta: float) -> void:
		
	if Input.is_action_just_pressed("quit"):
		var main_menu = load("res://assets/scenes/main_menu.tscn").instantiate()
		get_tree().root.get_node("Level").queue_free()
		get_tree().root.add_child(main_menu)
		
	if Input.is_action_just_pressed("space"):
		shoot()
		
	if Input.is_action_just_pressed("change_playmode"):
		if GameManager.play_mode == 0:
			GameManager.play_mode = 1
			$ship_cockpit.visible = true
			$FirstPersonCamera.set_current(true)
		else:
			GameManager.play_mode = 0
			$ship_cockpit.visible = false
			$FirstPersonCamera.set_current(false)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction
	if GameManager.play_mode == 0:
		direction = (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	else:
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
		velocity.x = lerp(velocity.x, direction.x * SPEED, accel * delta)
		velocity.z = lerp(velocity.z, direction.z * SPEED, accel * delta)
	else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.x = lerp(velocity.x, 0.0, accel * delta)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
		velocity.z = lerp(velocity.z, 0.0, accel * delta)

	move_and_slide()

func shoot() -> void:
	if get_tree().root.get_node_or_null("PlayerProjectile") == null:
		var newProjectile = projectile.instantiate()
		get_tree().root.add_child(newProjectile)
		newProjectile.name = "PlayerProjectile"
		newProjectile.global_position.x = self.global_position.x
		newProjectile.global_position.z = self.global_position.z - 8
		newProjectile.collision_mask = 2
		$SFX.play()
