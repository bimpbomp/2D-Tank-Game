extends KinematicBody2D
class_name Player


signal player_fired_bullet(bullet, position, direction)

export (int) var speed = 100
# rotation speed in degrees (converted to radians) per second
export (float) var rotate_speed = 80 * PI/180


var velocity := Vector2()
var rotation_velocity : float = 0


onready var turret = $Turret
onready var health_stat = $Health


# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_collision_exception_with(tank_turret)
	turret_animation_player.connect("animation_finished", self, "_make_ready_to_fire", ["fire"])
	turret.connect("turret_fired", self, "fire")


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
		turret.fire()


func fire(bullet_instance, location: Vector2, direction: Vector2):
	emit_signal("player_fired_bullet", bullet_instance, location, direction)


func handle_hit():
	health_stat.health -= 20
	print("Player hit. Health ", health_stat.health)


func _make_ready_to_fire(_a, _b):
	ready_to_fire = true
