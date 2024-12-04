extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_score() -> void:
	$ScoreLabel.text = "Score: " + str(GameManager.score)
	pass
	
func _on_button_pressed() -> void:
	var main_menu = load("res://assets/scenes/main_menu.tscn").instantiate()
	get_tree().root.add_child(main_menu)
	get_tree().root.get_node("Level").queue_free()
	pass # Replace with function body.
