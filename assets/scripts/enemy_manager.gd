extends Node3D

var enemyShip1 = load("res://assets/scenes/enemy.tscn")
var place = 0

#-120, 0, -120 -- top left

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_grid()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawn_grid() -> void:
	for x in 10:
		for z in 3:
			var newEnemy = enemyShip1.instantiate()
			add_child(newEnemy)
			newEnemy.global_position = Vector3(-120 + 50 + (x * 15), 0, -120 + (z * 15))
			

func _on_march_timer_timeout() -> void:
	print(place)
	
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
