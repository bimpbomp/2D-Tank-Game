extends KinematicBody2D


signal player_fired_bullet(bullet, position, direction)

export (int) var speed = 100
# rotation speed in degrees (converted to radians) per second
export (float) var rotate_speed = 80 * PI/180
export (PackedScene) var Bullet

var velocity := Vector2()
var rotation_velocity : float = 0


var ready_to_fire := true


onready var tank_turret : KinematicBody2D = $Turret
onready var turret_animation_player : AnimationPlayer = $Turret/AnimationPlayer
onready var end_of_gun : Position2D = $Turret/EndOfBarrel
onready var gun_direction : Position2D = $Turret/GunDirection
onready var attack_cooldown : Timer = $AttackCooldown


# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_collision_exception_with(tank_turret)
	turret_animation_player.connect("animation_finished", self, "_make_ready_to_fire", ["fire"])


func _physics_process(delta):
	if is_instance_valid(self):
		# rotation inputs
		rotation_velocity = 0
		if Input.is_action_pressed("turn_left"):
			rotation_velocity -= rotate_speed
		if Input.is_action_pressed("turn_right"):
			rotation_velocity += rotate_speed
		
		# apply rotation
		rotate(rotation_velocity * delta)
		
		var vel_direction = 0
		# movement inputs
		if Input.is_action_pressed("move_forwards"):
			vel_direction += 1
		if Input.is_action_pressed("move_backwards"):
			vel_direction -= 1
		
		# applying velocity
		if vel_direction != 0:
			velocity = Vector2.RIGHT.rotated(rotation) * vel_direction * speed
			velocity = move_and_slide(velocity, Vector2.ZERO)
		
		# feel like i will need to move the actual firing code to a separate location
		# so it can be reused for enemies also
		if tank_turret != null:
			tank_turret.look_at(get_global_mouse_position())

	else:
		queue_free()


func _unhandled_input(event):
	if event.is_action_pressed("fire"):
		fire()


func fire():


	if ready_to_fire and attack_cooldown.is_stopped():
		# start the animation, prevent more firing until animation has finished
		turret_animation_player.play("fire")
		ready_to_fire = false
		
		var bullet_instance = Bullet.instance()
		var direction = end_of_gun.global_position.direction_to(gun_direction.global_position).normalized()
		emit_signal("player_fired_bullet", bullet_instance, end_of_gun.global_position, direction)
		attack_cooldown.start()


func _make_ready_to_fire(_a, _b):
	ready_to_fire = true
