extends CharacterBody3D

#Credit to KidsCanCode for the player ship controller

@export var max_speed = 50.0
@export var accel = 2.0

var forward_speed = 0.0

@export var pitch_speed = 1.5
@export var roll_speed = 1.5
@export var yaw_speed = 0.65

var pitch_input = 0.0
var roll_input = 0.0
var yaw_input = 0.0

@export var input_response = 8.0
@export var projectile = load("res://assets/scenes/arcade_projectile.tscn")

func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("quit"):
		var main_menu = load("res://assets/scenes/main_menu.tscn").instantiate()
		get_tree().root.get_node("Level").queue_free()
		get_tree().root.add_child(main_menu)
		

	if Input.is_action_just_pressed("space"):
		shoot()

	if Input.is_action_pressed("accelerate"):
		forward_speed = lerp(forward_speed, max_speed, accel * delta)
	if Input.is_action_pressed("deccelerate"):
		forward_speed = lerp(forward_speed, 0.0, accel * delta)
	
	pitch_input = lerp(pitch_input, Input.get_axis("pitch_down", "pitch_up"),
		input_response * delta)
	roll_input = lerp(roll_input, Input.get_axis("roll_right", "roll_left"),
		input_response * delta)
	yaw_input = roll_input
	
	if Input.is_action_just_pressed("change_playmode"):
		if GameManager.play_mode == 0:
			GameManager.play_mode = 1
			$ship_cockpit.visible = true
			$FirstPersonCamera.set_current(true)
			$Dot.visible = true
		else:
			GameManager.play_mode = 0
			$ship_cockpit.visible = false
			$FirstPersonCamera.set_current(false)
			$Dot.visible = false
		
	transform.basis = transform.basis.rotated(transform.basis.z.normalized(), roll_input * roll_speed * delta)
	transform.basis = transform.basis.rotated(transform.basis.x.normalized(), pitch_input * pitch_speed * delta)
	transform.basis = transform.basis.rotated(transform.basis.y.normalized(), yaw_input * yaw_speed * delta)
	transform.basis = transform.basis.orthonormalized()
		
	velocity = -transform.basis.z * forward_speed
	move_and_collide(velocity * delta)

func shoot() -> void:
	if get_tree().root.get_node_or_null("PlayerProjectile") == null:
		var newProjectile = projectile.instantiate()
		#print("shoot")
		get_tree().root.add_child(newProjectile)
		newProjectile.name = "PlayerProjectile"
		newProjectile.global_position.x = self.global_position.x
		newProjectile.global_position.z = self.global_position.z
		newProjectile.global_position.y = self.global_position.y
		newProjectile.collision_mask = 2
		newProjectile.dir = -global_transform.basis.z
		$SFX.play()
