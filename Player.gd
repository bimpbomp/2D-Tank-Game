extends KinematicBody2D


export (int) var speed = 100
# rotation speed in degrees (converted to radians) per second
export (float) var rotateSpeed = 80 * PI/180

export (PackedScene) var Bullet

var velDirection : int = 0
var vel := Vector2()
var rotationVelocity : float = 0

var readyToFire := true

onready var tankTurret : KinematicBody2D = $Turret
onready var turretAnimationPlayer : AnimationPlayer = $Turret/AnimationPlayer
onready var endOfGun : Position2D = $Turret/EndOfBarrel


# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_collision_exception_with(tankTurret)
	turretAnimationPlayer.connect("animation_finished", self, "_make_ready_to_fire", ["fire"])


func _physics_process(delta):
	if is_instance_valid(self):
		# rotation inputs
		rotationVelocity = 0
		if Input.is_action_pressed("turn_left"):
			rotationVelocity -= rotateSpeed
		if Input.is_action_pressed("turn_right"):
			rotationVelocity += rotateSpeed
		
		# apply rotation
		rotate(rotationVelocity * delta)
		
		velDirection = 0
		# movement inputs
		if Input.is_action_pressed("move_forwards"):
			velDirection += 1
		if Input.is_action_pressed("move_backwards"):
			velDirection -= 1
		
		# applying velocity
		if velDirection != 0:
			vel = Vector2.RIGHT.rotated(rotation) * velDirection * speed
			vel = move_and_slide(vel, Vector2.ZERO)
		
		# feel like i will need to move the actual firing code to a separate location
		# so it can be reused for enemies also
		if tankTurret != null:
			tankTurret.look_at(get_global_mouse_position())

	else:
		queue_free()
		
func _unhandled_input(event):
	if event.is_action_pressed("fire"):
		fire()

func fire():
	
	if readyToFire:
		# start the animation, prevent more firing until animation has finished
		turretAnimationPlayer.play("fire")
		readyToFire = false
		
		var bullet_instance = Bullet.instance()
		get_tree().get_root().add_child(bullet_instance)
		bullet_instance.global_position = endOfGun.global_position 
		var direction = tankTurret.global_position.direction_to(endOfGun.global_position).normalized()
		bullet_instance.set_direction(direction)
		bullet_instance.rotation = direction.angle()
		#bullet_instance.bullet_owner = bullet_owner
	
func _make_ready_to_fire(_a, _b):
	readyToFire = true
