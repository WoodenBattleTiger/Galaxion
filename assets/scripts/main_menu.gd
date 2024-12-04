extends Control

var level = preload("res://assets/scenes/level.tscn").instantiate()
var arcade_level = preload("res://assets/scenes/arcade_level.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().root.get_node_or_null("PlayerProjectile"):
		get_tree().root.get_node("PlayerProjectile").queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	get_tree().root.add_child(level)
	queue_free()
	pass # Replace with function body.


func _on_arcade_pressed() -> void:
	get_tree().root.add_child(arcade_level)
	queue_free()
	pass # Replace with function body.


func _on_x_button_pressed() -> void:
	$ControlsPanel.visible = false
	pass # Replace with function body.


func _on_controls_pressed() -> void:
	$ControlsPanel.visible = true
