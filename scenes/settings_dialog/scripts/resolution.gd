extends HBoxContainer


onready var option_button: OptionButton = $OptionButton


func _ready() -> void:
	option_button.add_item("1920x1080")
	option_button.set_meta("0", Vector2(1920, 1080))

	option_button.add_item("1600x900")
	option_button.set_meta("1", Vector2(1600, 900))

	option_button.add_item("1366x768")
	option_button.set_meta("2", Vector2(1366, 768))

	option_button.add_item("1280x720")
	option_button.set_meta("3", Vector2(1280, 720))


	var resolution := ProjectSettingsOverride.get_resolution()

	if resolution.x > 0 and resolution.y > 0:
		var custom_resolution := true
		for meta in option_button.get_meta_list():
			if option_button.get_meta(meta) == resolution:
				option_button.select(int(meta))
				custom_resolution = false
				break
		if custom_resolution:
			var index := option_button.get_item_count()
			option_button.add_item("%dx%d (Custom)" % [resolution.x, resolution.y])
			option_button.set_meta(str(index), resolution)
			option_button.select(index)


func update_resolution(index: int) -> void:
	if not OS.is_window_fullscreen():
		OS.set_window_size(option_button.get_meta(str(index)))
		OS.set_window_position((OS.get_screen_size() - OS.get_window_size()) / 2)
	ProjectSettingsOverride.set_resolution(OS.get_window_size())


func _on_OptionButton_item_selected(index: int) -> void:
	update_resolution(index)


func _exit_tree() -> void:
	ProjectSettingsOverride.set_resolution(option_button.get_meta(str(option_button.selected)))
