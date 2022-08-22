extends KinematicBody2D


export (int) var speed = 100
# rotation speed in degrees (converted to radians) per second
export (float) var rotateSpeed = 80 * PI/180

var velDirection : int = 0
var vel := Vector2()
var rotationVelocity : float = 0

var tankBody : KinematicBody2D
var tankTurret : KinematicBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	tankBody = get_node_or_null(".")
	tankTurret = get_node_or_null("Turret")
	tankBody.add_collision_exception_with(tankTurret)


func _physics_process(delta):
	if is_instance_valid(tankBody):
		# rotation inputs
		rotationVelocity = 0
		if Input.is_action_pressed("turn_left"):
			rotationVelocity -= rotateSpeed
		if Input.is_action_pressed("turn_right"):
			rotationVelocity += rotateSpeed
		
		# apply rotation
		tankBody.rotate(rotationVelocity * delta)
		
		velDirection = 0
		# movement inputs
		if Input.is_action_pressed("move_forwards"):
			velDirection += 1
		if Input.is_action_pressed("move_backwards"):
			velDirection -= 1
		
		# applying velocity
		if velDirection != 0:
			vel = Vector2.RIGHT.rotated(tankBody.rotation) * velDirection * speed
			vel = tankBody.move_and_slide(vel, Vector2.ZERO)
		
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
	# tankTurret._on_fire(tankBody)
	pass
