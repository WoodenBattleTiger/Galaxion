extends Area3D

const SPEED = 300.0

var dir: Vector3
var velocity = 0

signal update_score

var sfx_node
var ui_node

@export var explosion_sprite_path = "res://assets/scenes/explosion_sprite.tscn"

func _ready() -> void:
	update_score.connect(get_tree().root.get_node("Level/ui").update_score)
	sfx_node = get_tree().root.get_node("Level/SFX")
	ui_node = get_tree().root.get_node("Level/ui")
	#look_at(dir, Vector3(0,1,0), true)
	pass

func _physics_process(delta: float) -> void:
	if dir:
		velocity = dir * SPEED
		
	translate(velocity * delta)

func _process(delta: float) -> void:
	await get_tree().create_timer(1.0).timeout
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
	body.queue_free()
	#sfx_node.stream = load("res://assets/audio/game_over.mp3")
	#sfx_node.play()
	if body.name == "ArcadePlayer":
		#player hit
		ui_node.get_node("GameOver").set_visible(true)
	queue_free()
