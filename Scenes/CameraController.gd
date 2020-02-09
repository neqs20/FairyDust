extends Camera

var pressed = false
var dis = -translation.length()
var cam_a = 0
var sensitivity = 0.3

onready var pivot = get_parent()
onready var player = pivot.get_parent().get_node("Player")

func _ready():
	look_at(pivot.translation, Vector3.UP)

func _physics_process(delta):
	if not pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pivot.set_translation(player.translation)
	var ray = get_world().get_direct_space_state().intersect_ray(player.global_transform.origin, global_transform.origin, [self])
	if not ray.empty():
		global_transform.origin = ray.position - (global_transform.basis.z.normalized() * 1.2)
		var distance = global_transform.origin.distance_to(player.global_transform.origin)
		if distance < 0.99:
			translation = Vector3(translation.x, -sin(rotation.x),-cos(rotation.x))

func _on_gui_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			pressed = event.pressed
		elif event.button_index == BUTTON_WHEEL_DOWN:
			dis -= 0.03
			translation = Vector3(translation.x, dis * sin(rotation.x), dis * cos(rotation.x))
			dis = clamp(dis,-2 * sqrt(2), -1)
		elif event.button_index == BUTTON_WHEEL_UP:
			dis += 0.03
			translation = Vector3(translation.x, dis * sin(rotation.x), dis * cos(rotation.x))
			dis = clamp(dis,-2 * sqrt(2), -1)
	if event is InputEventMouseMotion:
		if pressed:
			pivot.rotate_y(deg2rad(-event.relative.x * sensitivity))
			var change = -event.relative.y * sensitivity
			if change + cam_a < 80 and change + cam_a > -30:
				rotate_x(-deg2rad(change))
				cam_a += change
			translation = Vector3(translation.x, dis * sin(rotation.x), dis * cos(rotation.x))
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
		
