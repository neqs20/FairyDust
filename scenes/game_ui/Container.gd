extends VBoxContainer


enum { MENTION_TAG = 64, MONSTER_TAG = 58, QUEST_TAG = 91 }

const PLAYER_NAME = "NeQs"

var regex := RegEx.new()
var style : StyleBoxFlat = null

onready var input: LineEdit = $input
onready var messages: RichTextLabel = $messages


func _ready() -> void:
	regex.compile("(\\[.+?\\])|(:.+?:)|(@[A-Za-z0-9]+)")
	style = messages.get("custom_styles/normal")
	set_process_internal(true)


func _on_input_text_entered(new_text: String) -> void:
	$input.clear()
	if new_text.empty():
		return
	Network.send_tcp((Packet.TEXT_CHAT + Chat.GLOBAL + new_text).to_utf8())
	#add_message(new_text)
	#send new_text to the server

func add_message(text: String) -> void:
	var matches := regex.search_all(text)
	for m in matches:
		match ord(m.get_string()[0]):
			MENTION_TAG:
				var player_name = m.get_string().right(1)
				match validate_player(player_name):
					OK:
						text = text.replace(m.get_string(), "[highlight=#3c414f][color=#44537d][url=%d]%s[/url][/color][/highlight]" % [get_player_id(player_name), m.get_string()])
					ERR_CYCLIC_LINK:
						text = "[highlight=#725f44]%s[/highlight]" % text.replace(m.get_string(), "[color=#44537d][url=%d]%s[/url][/color]" % [Network.id, m.get_string()])
			QUEST_TAG:
				var quest_name = m.get_string().substr(1, m.get_string().length() - 2)
				var a = randi() % 201
				print(a)
				text = text.replace(m.get_string(), "[url=%d]%s[/url]" % [a, m.get_string()])
			_:
				print(m.get_string())
	messages.append_bbcode(text)
	messages.newline()


func get_quest_id(quest_name: String) -> int:
	return randi() % 20


func validate_player(p_name: String) -> int:
	if PLAYER_NAME == p_name:
		return ERR_CYCLIC_LINK
	#if players.has(p_name):
	#	return OK
	return ERR_CANT_RESOLVE

func get_player_id(name: String) -> int:
	#return players[name]
	return 0

func _on_messages_mouse_exited():
	style.bg_color = Color("#19ffffff")


func _on_messages_mouse_entered():
	style.bg_color = Color("#3cffffff")

