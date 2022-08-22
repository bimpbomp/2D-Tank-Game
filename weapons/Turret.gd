extends KinematicBody2D


signal turret_fired(bullet, location, direction)


export (PackedScene) var Bullet


onready var tank_turret : KinematicBody2D = $Turret
onready var turret_animation_player : AnimationPlayer = $AnimationPlayer
onready var end_of_gun : Position2D = $EndOfBarrel
onready var gun_direction : Position2D = $GunDirection
onready var attack_cooldown : Timer = $AttackCooldown
var ready_to_fire := true

func fire():
	if ready_to_fire and attack_cooldown.is_stopped() and Bullet != null:
		# start the animation, prevent more firing until animation has finished
		turret_animation_player.play("fire")
		ready_to_fire = false
		
		var bullet_instance = Bullet.instance()
		var direction = end_of_gun.global_position.direction_to(gun_direction.global_position).normalized()
		emit_signal("player_fired_bullet", bullet_instance, end_of_gun.global_position, direction)
		attack_cooldown.start()
