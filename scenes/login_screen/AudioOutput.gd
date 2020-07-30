extends AudioStreamPlayer


var audio_stream := AudioStreamSample.new()

func _ready() -> void:
	Network.connect("voice_message_received", self, "_voice_message_received")


func _voice_message_received(data: PoolByteArray) -> void:
	audio_stream.data = data.subarray(0, data.size() - 1 - 9)
	audio_stream.format = AudioStreamSample.FORMAT_16_BITS
	stream = audio_stream
	play()
