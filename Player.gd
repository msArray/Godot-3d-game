extends CharacterBody3D
# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

const SPEED  = 10.0
const JUMP_VELOCITY = 5.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var move_mag = 1
var target_velocity = Vector3.ZERO
var sens_horizontal = 0.5

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-1 * event.relative.x))
		$pivot.rotate_x(deg_to_rad(-1 * event.relative.y))


func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		move_mag = 0.5
	else:
		move_mag = 1
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir = Input.get_vector("Move_Left","Move_Right","Move_Forward","Move_Back")
	var direction = (transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * move_mag
		velocity.z = direction.z * SPEED * move_mag
	else:
		velocity.x = move_toward(velocity.x,0,SPEED)
		velocity.z = move_toward(velocity.z,0,SPEED)
	
	move_and_slide()
