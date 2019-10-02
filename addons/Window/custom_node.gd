tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Window", "Popup", preload("res://addons/Window/Window.gd"), preload("res://addons/Window/Window.png"))
	
func _exit_tree():
	remove_custom_type("Window")