extends Area2D


export (int) var speed = 300

var direction := Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed * delta
		
		global_position += velocity

func set_direction(direction: Vector2):
	self.direction = direction
