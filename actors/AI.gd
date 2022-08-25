extends Node2D


signal state_changed(new_state)


enum State {
	PATROL,
	ENGAGE
}


onready var player_detection_zone = $PlayerDetectionZone


var current_state = State.PATROL setget set_state
var actor = null
var player: Player = null
var turret: Turret = null


func _process(delta):
	match current_state:
		State.PATROL:
			pass
		State.ENGAGE:
			if player != null and turret != null:
				turret.rotation = turret.global_position.direction_to(player.global_position).angle()
				turret.fire()
			else:
				print("Player or turret for enemy is null")
		_:
			print("Error: state for enemy that shouldn't exist")


func initialise(actor, turret: Turret):
	self.actor = actor
	self.turret = turret


func set_state(new_state: int):
	if current_state == new_state:
		return
		
	current_state = new_state
	emit_signal("state_changed", current_state)


func _on_PlayerDetectionZone_body_entered(body):
	if body.is_in_group("player"):
		set_state(State.ENGAGE)
		player = body
