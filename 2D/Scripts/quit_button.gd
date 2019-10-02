extends Button


func _on_quit_button_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		Application.quit()
