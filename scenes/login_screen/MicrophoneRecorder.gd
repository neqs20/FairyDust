extends AudioStreamPlayer


const MIN_SIZE := 0.1

var recording := false
var microphone : AudioEffectRecord
var offset := 0.0


func _ready() -> void:
	microphone = AudioServer.get_bus_effect(AudioServer.get_bus_index("Record"), 0)

func _process(delta: float) -> void:
	if Input.is_action_pressed("talk"):
		recording = true
	else:
		recording = false
	if recording:
		if microphone.is_recording_active():
			if offset >= MIN_SIZE:
				microphone.set_recording_active(false)
				if not microphone.get_recording() == null:
					var data := (Packet.VOICE).to_ascii()
					data.append_array(microphone.get_recording().get_data())
					data.append_array(hex(microphone.get_recording().format, 1).to_ascii())
					data.append_array(hex(microphone.get_recording().mix_rate, 8).to_ascii())
					print(microphone.get_recording().get_data().size())
					Network.send_udp(data, 1)
				microphone.set_recording_active(true)
				offset = 0.0
			offset += delta
		else:
			microphone.set_recording_active(true)
	else:
		microphone.set_recording_active(false)
	"""
	if Input.is_action_pressed("talk"):
		recording = true
	else:
		recording = false
	if recording:
		if microphone.is_recording_active():
			if not microphone.is_recording_data_empty():
				if not microphone.get_recording() == null:
					microphone.set_recording_active(false)
					var data := (Packet.VOICE).to_ascii()
					data.append_array(microphone.get_recording().get_data())
					print(microphone.get_recording().get_data().size())
					Network.send_udp(data, 1)
					microphone.set_recording_active(true)
		else:
			microphone.set_recording_active(true)
	else:
		microphone.set_recording_active(false)
	"""
"""
extends AudioStreamPlayer


const MIN_SIZE := 0.1

var recording := false
var microphone : AudioEffectRecord
var offset := 0.0


func _ready() -> void:
	microphone = AudioServer.get_bus_effect(AudioServer.get_bus_index("Record"), 0)

func _process(delta: float) -> void:
	if Input.is_action_pressed("talk"):
		recording = true
	else:
		recording = false
	if recording:
		if microphone.is_recording_active():
			if offset >= MIN_SIZE:
				microphone.set_recording_active(false)
				if not microphone.get_recording() == null:
					var data := (Packet.VOICE).to_ascii()
					data.append_array(microphone.get_recording().get_data())
					Network.send_udp(data, 1)
				microphone.set_recording_active(true)
				offset = 0.0
			offset += delta
		else:
			microphone.set_recording_active(true)
	else:
		microphone.set_recording_active(false)
"""
