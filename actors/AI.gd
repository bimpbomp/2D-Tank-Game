extends Node2D


signal state_changed(new_state)


enum State {
	PATROL,
	ENGAGE
}


onready var patrol_timer = $PatrolTimer


var current_state = -1 setget set_state
var actor: KinematicBody2D = null
var turret: Turret = null


# ENGAGE state
var target: KinematicBody2D = null
var team: int = -1


# PATROL state
var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached := false
var actor_velocity: Vector2 = Vector2.ZERO


func _ready():
	pass


func _physics_process(_delta):
	if is_instance_valid(self):
		match current_state:
			State.PATROL:
				if not patrol_location_reached:
					turret.reset_rotation()
					actor.move_and_slide(actor_velocity)
					actor.rotate_towards(patrol_location)
					if actor.global_position.distance_to(patrol_location) < 5:
						patrol_location_reached = true
						actor_velocity = Vector2.ZERO
						patrol_timer.start()
			State.ENGAGE:
				if target != null and turret != null:
					turret.rotate_towards(target.global_position)
					
					var angle_to_player = turret.global_position.direction_to(target.global_position).angle()
					if abs(turret.global_rotation - angle_to_player) < 0.1:
						turret.fire()
				else:
					print("Player or turret for enemy is null in ENGAGE state")
			_:
				print("Unknown AI state, setting to default state of PATROL")
				set_state(State.PATROL)


func initialise(new_actor: KinematicBody2D, new_turret: Turret, new_team: int):
	self.actor = new_actor
	self.turret = new_turret
	self.team = new_team
	
	self.turret.connect("turret_out_of_ammo", self, "handle_reload")


func set_state(new_state: int):
	if current_state == new_state:
		return
		
	if new_state == State.PATROL:
		origin = global_position
		patrol_location_reached = true
		patrol_timer.start()
		
	current_state = new_state
	emit_signal("state_changed", current_state)
	
	
func handle_reload():
	turret.start_reload()


func _on_PatrolTimer_timeout():
	var patrol_range = 50
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false
	actor_velocity = actor.velocity_towards(patrol_location)


func _on_DetectionZone_body_entered(body):
	if !target and body.has_method("get_team") and body.get_team() != self.team:
		set_state(State.ENGAGE)
		target = body


func _on_DetectionZone_body_exited(body):
	if target and body == target:
		set_state(State.PATROL)
		target = null
