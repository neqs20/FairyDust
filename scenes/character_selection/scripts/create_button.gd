extends Button


export(NodePath) var create_container_path
export(NodePath) var group_path

onready var create_container: Control = get_node(create_container_path)
onready var main_group: Control = get_node(group_path)


func _on_Create_toggled(button_pressed: bool) -> void:
	SceneChanger.fade()
	yield(SceneChanger.animation, "animation_finished")
	main_group.visible = not button_pressed
	
	create_container.visible = button_pressed
