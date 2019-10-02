extends Control


func _process(delta):
	if Network.authentication:
		get_tree().change_scene("res://3D/3D World.tscn")
		print("login_screen: changing scene")

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		Application.quit()


