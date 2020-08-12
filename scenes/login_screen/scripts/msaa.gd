extends HBoxContainer


onready var option_button: OptionButton = $OptionButton


func _ready() -> void:
	option_button.add_item("Disabled")
	option_button.add_item("2x")
	option_button.add_item("4x")
	option_button.add_item("8x")
	option_button.add_item("16x")

	option_button.select(ProjectSettingsOverride.get_msaa())


func _on_OptionButton_item_selected(index: int) -> void:
	get_viewport().set_msaa(index)
	ProjectSettingsOverride.set_msaa(index)
