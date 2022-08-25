extends KinematicBody2D


onready var health_stat = $Health
onready var ai = $AI
onready var turret = $Turret


export (int) var speed = 100


func _ready():
	ai.initialise(self, turret)
	

func rotate_towards(location: Vector2):
	rotation = lerp(rotation, global_position.direction_to(location).angle(), 0.1)
	
	
func velocity_towards(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * speed
	

func handle_hit():
	health_stat.health -= 20
	print("Enemy hit. Health ", health_stat.health)
	
	if health_stat.health <= 0:
		queue_free()
