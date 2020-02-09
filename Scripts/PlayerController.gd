extends KinematicBody

onready var pivot = get_parent().get_node("pivot")

var gravity = Vector3.DOWN * 12
var vel := Vector3()

var speed = 2
var strafe_speed = 0.9

var jumping = false

func _physics_process(delta):
	vel += gravity * delta
	var vy = vel.y
	vel = Vector3()
	if Input.is_action_pressed("game_w"):
		vel += transform.basis.z * speed
		transform.basis = Basis(Quat(transform.basis.orthonormalized()).slerp(Quat(pivot.transform.basis.orthonormalized()), 0.2))
	elif Input.is_action_pressed("game_s"):
		vel += -transform.basis.z * speed
		transform.basis = Basis(Quat(transform.basis.orthonormalized()).slerp(Quat(pivot.transform.basis.orthonormalized()), 0.2))
	#	set_rotation(lerp(get_rotation(), pivot.get_rotation(), 0.2))
	if Input.is_action_pressed("game_q"):
		vel += transform.basis.x * strafe_speed
	elif Input.is_action_pressed("game_e"):
		vel += -transform.basis.x * strafe_speed
	vel.y = vy
	jumping = false
	if Input.is_action_pressed("game_space"):
		jumping = true
	vel = move_and_slide(vel, Vector3.UP, true)
	if Input.is_action_pressed("game_a"):
		rotate_y(deg2rad(100) * delta)
		pivot.rotate_y(deg2rad(100) * delta)
		#var new_basis = Basis(Vector3(0, 1, 0), deg2rad(100) * delta)
		#transform.basis *= new_basis
		#pivot.transform.basis *= new_basis
	if Input.is_action_pressed("game_d"):
		rotate_y(-deg2rad(100) * delta)
		pivot.rotate_y(-deg2rad(100) * delta)
	if jumping and is_on_floor():
		vel.y = 5
