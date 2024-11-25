extends CharacterBody3D


const SPEED = 80.0
const JUMP_VELOCITY = 4.5

var play_mode = 0

var projectile = load("res://assets/scenes/projectile.tscn")

func _physics_process(delta: float) -> void:
		
	if Input.is_action_just_pressed("space"):
		shoot()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction
	if play_mode == 0:
		direction = (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	else:
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func shoot() -> void:
	if get_tree().root.get_node_or_null("Projectile") == null:
		var newProjectile = projectile.instantiate()
		get_tree().root.add_child(newProjectile)
		newProjectile.global_position.x = self.global_position.x
		newProjectile.collision_mask = 2
