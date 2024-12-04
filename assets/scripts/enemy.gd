extends Area3D

var firing = false
var projectile = load("res://assets/scenes/projectile.tscn")
var sfx_node
var ui_node



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sfx_node = get_tree().root.get_node("Level/SFX")
	ui_node = get_tree().root.get_node("Level/ui")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("debug_action"):
		#fire_projectiles()
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		#ship and player have collided, game over
		sfx_node.stream = load("res://assets/audio/game_over.mp3")
		sfx_node.play()
		ui_node.get_node("GameOver").set_visible(true)
		body.queue_free()
		queue_free()

func start_firing():
	firing = true
	if firing:
		fire_projectiles()
		#await get_tree().create_timer(1.0).timeout
		
		
func fire_projectiles():
	for i in 3:
		var newProjectile = projectile.instantiate()
		get_tree().root.add_child(newProjectile)
		newProjectile.dir = -1
		newProjectile.global_position.x = self.global_position.x
		newProjectile.global_position.z = self.global_position.z + 8
		newProjectile.collision_mask = 1
		await get_tree().create_timer(0.2).timeout
