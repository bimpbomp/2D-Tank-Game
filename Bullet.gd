extends Area2D
class_name Bullet


export (int) var speed = 300


onready var killTimer = $KillTimer


var direction := Vector2.ZERO


func _ready():
	killTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed * delta
		
		global_position += velocity


func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()


func _on_KillTimer_timeout():
	queue_free()
