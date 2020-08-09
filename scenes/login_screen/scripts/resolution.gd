tool
extends HBoxContainer


onready var option_button: OptionButton = $OptionButton

func _ready() -> void:
	if option_button.get_item_count() > 0:
		option_button.clear()
	option_button.add_item("1920x1080")
	option_button.set_meta("0", Vector2(1920, 1080))

	option_button.add_item("1600x900")
	option_button.set_meta("1", Vector2(1600, 900))

	option_button.add_item("1366x768")
	option_button.set_meta("2", Vector2(1366, 768))

	option_button.add_item("1280x720")
	option_button.set_meta("3", Vector2(1280, 720))

	if not Engine.is_editor_hint():
		var resolution = Config.get_resolution()
		#OS.set_window_size(resolution)
		#OS.set_window_position((OS.get_screen_size() - resolution) / 2)
		print(OS.get_window_size())

	#print(screen_size - Vector2(20, 20))
	#for meta in option_button.get_meta_list():
	#	if option_button.get_meta(meta) == screen_size - Vector2(20, 20):
	#		print(123)
	#		option_button.select(int(meta))
	#		OS.set_window_size(screen_size)
	#		OS.set_window_position(Vector2(0,0))


func update_resolution(index: int) -> void:
	OS.set_window_size(option_button.get_meta(str(index)))


func _on_OptionButton_item_selected(index):
	update_resolution(index)
