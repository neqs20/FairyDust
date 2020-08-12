extends HBoxContainer

export(NodePath) var resolution_option

onready var resolution: HBoxContainer = get_node(resolution_option)
onready var option_button: OptionButton = $OptionButton


func _ready() -> void:
	option_button.add_item("Windowed")
	option_button.add_item("Fullscreen")
	
	var is_fullscreened = ProjectSettingsOverride.is_fullscreen()
	if is_fullscreened:
		option_button.select(1)
	else:
		option_button.select(0)


func _on_OptionButton_item_selected(index: int) -> void:
	match option_button.get_item_text(index):
		"Windowed":
			OS.set_window_fullscreen(false)
			resolution.update_resolution(resolution.option_button.selected)
			ProjectSettingsOverride.set_fullscreen(false)
		"Fullscreen":
			OS.set_window_fullscreen(true)
			ProjectSettingsOverride.set_fullscreen(true)
