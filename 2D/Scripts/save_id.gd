extends CheckBox


onready var login_field = $"../login_field"


func _ready():
	pressed = Config.current["save_id"]


func _on_save_id_pressed():
	Config.update("save_id", pressed)
	Config.update("login_field", login_field.text)
	print("save_id: button pressed, updating config")