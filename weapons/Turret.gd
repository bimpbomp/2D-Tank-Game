extends Node2D
class_name Turret



export (PackedScene) var Bullet


onready var turret_animation_player : AnimationPlayer = $AnimationPlayer
onready var end_of_gun : Position2D = $EndOfBarrel
onready var gun_direction : Position2D = $GunDirection
onready var attack_cooldown : Timer = $AttackCooldown
var ready_to_fire := true


func _ready():
	turret_animation_player.connect("animation_finished", self, "_make_ready_to_fire", ["fire"])
	
	
func gun_facing_direction() -> Vector2:
	return end_of_gun.global_position.direction_to(gun_direction.global_position).normalized()


func rotate_towards(location: Vector2):
	global_rotation = lerp_angle(global_rotation, global_position.direction_to(location).angle(), 0.1)
	
func reset_rotation():
	rotation = 0


func fire():
	if ready_to_fire and attack_cooldown.is_stopped() and Bullet != null:
		# start the animation, prevent more firing until animation has finished
		turret_animation_player.play("fire")
		ready_to_fire = false
		
		var bullet_instance = Bullet.instance()
		var direction = gun_facing_direction()
		GlobalSignals.emit_signal("bullet_fired", bullet_instance, end_of_gun.global_position, direction)
		attack_cooldown.start()

func _make_ready_to_fire(_a, _b):
	ready_to_fire = true
