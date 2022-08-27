extends KinematicBody2D


onready var health_stat = $Health
onready var ai = $AI
onready var turret: Turret = $Turret
onready var team = $Team


export (int) var speed = 100


func _ready():
	ai.initialise(self, turret, team.team)
	turret.initialise(self, team.team)
	

func rotate_towards(location: Vector2):
	rotation = lerp(rotation, global_position.direction_to(location).angle(), 0.1)
	
	
func velocity_towards(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * speed


func get_team() -> int:
	return team.team


func handle_hit():
	health_stat.health -= 20
	print("Enemy hit. Health ", health_stat.health)
	
	if health_stat.health <= 0:
		queue_free()
