extends Node2D


signal state_changed(new_state)


enum State {
	PATROL,
	ENGAGE
}


onready var player_detection_zone = $PlayerDetectionZone
onready var patrol_timer = $PatrolTimer


var current_state = -1 setget set_state
var actor: KinematicBody2D = null
var turret: Turret = null


# ENGAGE state
var player: Player = null


# PATROL state
var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached := false
var actor_velocity: Vector2 = Vector2.ZERO


func _ready():
	set_state(State.PATROL)


func _physics_process(delta):
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				actor.move_and_slide(actor_velocity)
				actor.rotate_towards(patrol_location)
				if actor.global_position.distance_to(patrol_location) < 5:
					patrol_location_reached = true
					actor_velocity = Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE:
			if player != null and turret != null:
				var direction_to_player = turret.gun_facing_direction().direction_to(player.global_position)
				turret.rotate_towards(direction_to_player)
				
				if abs(turret.global_rotation - direction_to_player.angle()) < 0.1:
					turret.fire()
			else:
				print("Player or turret for enemy is null in ENGAGE state")
		_:
			print("Error: state for enemy that shouldn't exist")


func initialise(actor, turret: Turret):
	self.actor = actor
	self.turret = turret


func set_state(new_state: int):
	if current_state == new_state:
		return
		
	if new_state == State.PATROL:
		origin = global_position
		patrol_location_reached = true
		patrol_timer.start()
		
	current_state = new_state
	emit_signal("state_changed", current_state)


func _on_PlayerDetectionZone_body_entered(body):
	if body.is_in_group("player"):
		set_state(State.ENGAGE)
		player = body


func _on_PlayerDetectionZone_body_exited(body):
	if player and body == player:
		set_state(State.PATROL)
		player = null


func _on_PatrolTimer_timeout():
	var patrol_range = 50
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false
	actor_velocity = actor.velocity_towards(patrol_location)
