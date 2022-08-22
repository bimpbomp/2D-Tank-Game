extends Area2D
class_name Bullet


export (int) var speed = 300


onready var kill_timer = $KillTimer


var direction := Vector2.ZERO


func _ready():
	kill_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed * delta
		
		global_position += velocity


func set_direction(new_direction: Vector2):
	direction = new_direction
	rotation += direction.angle()


func _on_KillTimer_timeout():
	queue_free()


func _on_Bullet_body_entered(body: Node):
	if body.has_method("handle_hit"):
		body.handle_hit()
		queue_free()
