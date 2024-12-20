extends Area3D


const SPEED = 100.0

var dir = 1 #1 up -1 down
var velocity = 0

signal update_score

var sfx_node
var ui_node

@export var explosion_sprite_path = "res://assets/scenes/explosion_sprite.tscn"

func _ready() -> void:
	update_score.connect(get_tree().root.get_node("Level/ui").update_score)
	sfx_node = get_tree().root.get_node("Level/SFX")
	ui_node = get_tree().root.get_node("Level/ui")

func _physics_process(delta: float) -> void:
	if dir == 1:
		velocity = Vector3(0, 0, -1) * SPEED
	else:
		velocity = Vector3(0, 0, 1) * SPEED
		
	translate(velocity * delta)
	
	if global_position.z < -get_window().size.y / 3:
		queue_free()


func _on_area_entered(area: Area3D) -> void:
	area.queue_free()
	GameManager.score += 50
	sfx_node.stream = load("res://assets/audio/explosion.mp3")
	sfx_node.play()
	update_score.emit()
	var explosion = load(explosion_sprite_path).instantiate()
	get_tree().root.get_node("Level").add_child(explosion)
	explosion.global_position = area.global_position
	
	queue_free()

func _on_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node3D) -> void:
	body.queue_free() #player hit
	sfx_node.stream = load("res://assets/audio/game_over.mp3")
	sfx_node.play()
	ui_node.get_node("GameOver").set_visible(true)
	queue_free()
