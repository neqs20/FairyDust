extends GridContainer


onready var vsync: CheckBox = $Vsync
onready var font_oversampling: CheckBox = $FontOversampling


func _ready() -> void:
	vsync.pressed = ProjectSettingsOverride.get_vsync()
	font_oversampling.pressed = ProjectSettingsOverride.get_font_oversampling()
	OS.set_use_vsync(vsync.pressed)
	get_tree().set_use_font_oversampling(font_oversampling.pressed)


func _on_Vsync_toggled(button_pressed: bool) -> void:
	ProjectSettingsOverride.set_vsync(button_pressed)
	OS.set_use_vsync(button_pressed)


func _on_FontOversampling_toggled(button_pressed: bool) -> void:
	ProjectSettingsOverride.set_font_oversampling(button_pressed)
	get_tree().set_use_font_oversampling(button_pressed)
