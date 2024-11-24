extends Node3D

var enemyShip1 = load("res://assets/scenes/enemy.tscn")
var place = 0
var flip = 0

var enemy_material = load("res://assets/materials/enemy_color.tres")

#vars for enemy movement
var height = 25
var duration = 1.0

#-120, 0, -120 -- top left

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_grid()
	start_launch_timer()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_action"):
		launch_enemy()
	
func spawn_grid() -> void:
	for slot in $Slots.get_children():
		var newEnemy = enemyShip1.instantiate()
		$Enemies.add_child(newEnemy)
		newEnemy.global_position = slot.position

func launch_enemy() -> void:
	if $Enemies.get_child_count() > 0:
		var child_idx = randi_range(0, $Enemies.get_child_count() - 1)
		var enemy_to_launch = $Enemies.get_child(child_idx)
		
		var tween_z = enemy_to_launch.create_tween()
		tween_z.tween_property(enemy_to_launch, "position:z", 140, 2.0)
		
		var tween_x := enemy_to_launch.create_tween().set_trans(Tween.TRANS_SINE)
		height = randi_range(20, 30)
		tween_x.tween_property(enemy_to_launch, "position:x", height, duration * 0.5).as_relative().set_ease(Tween.EASE_OUT)
		tween_x.tween_property(enemy_to_launch, "position:x", -height, duration * 0.5).as_relative().set_ease(Tween.EASE_IN)
		tween_x.tween_property(enemy_to_launch, "position:x", -height, duration * 0.5).as_relative().set_ease(Tween.EASE_OUT)
		tween_x.tween_property(enemy_to_launch, "position:x", height, duration * 0.5).as_relative().set_ease(Tween.EASE_IN)

		await tween_z.finished
		await tween_x.finished
		
		enemy_to_launch.global_position.z = -140
		var return_tween = enemy_to_launch.create_tween()
		return_tween.tween_property(enemy_to_launch, "global_position", $Slots.get_child(child_idx).position, 1.0)
	
func _on_tick_timer_timeout() -> void:
	if flip == 0:
		for enemy in $Enemies.get_children():
			if enemy.get_node_or_null("enemy ship 1/switching meshes") != null:
				var meshesToChange = enemy.get_node("enemy ship 1/switching meshes")
				for mesh in meshesToChange.get_children():
					mesh.set_surface_override_material(0, enemy_material)
		flip = 1
	else:
		for enemy in $Enemies.get_children():
			if enemy.get_node_or_null("enemy ship 1/switching meshes") != null:
				var meshesToChange = enemy.get_node("enemy ship 1/switching meshes")
				for mesh in meshesToChange.get_children():
					mesh.set_surface_override_material(0, null)
		flip = 0	
		


func _on_march_timer_timeout() -> void:
	#print(place)
	
	if place == 0:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", Vector3(-100, 0, -120), 1.5)
	elif place == 1:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", Vector3(-70, 0, -120), 1.5)
	elif place == 2:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", Vector3(-40, 0, -120), 1.5)
	elif place == 3:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", Vector3(-70, 0, -120), 1.5)
	
	if place < 3:
		place += 1
	else:
		place = 0

func start_launch_timer() -> void:
	$LaunchTimer.wait_time = randf_range(2.0, 5.0)
	$LaunchTimer.start()

func _on_launch_timer_timeout() -> void:
	launch_enemy()
	start_launch_timer()
	
