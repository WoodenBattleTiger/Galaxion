extends Area3D


const SPEED = 100.0

var dir = 1 #1 up -1 down
var velocity = 0

func _physics_process(delta: float) -> void:
	if dir == 1:
		velocity = Vector3(0, 0, -1) * SPEED
	else:
		velocity = Vector3(0, 0, 1) * SPEED
		
	translate(velocity * delta)


func _on_area_entered(area: Area3D) -> void:
	area.queue_free()
	queue_free()


func _on_screen_exited() -> void:
	queue_free()
