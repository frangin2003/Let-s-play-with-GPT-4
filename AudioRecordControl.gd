#extends Control
#
#var effect  # See AudioEffect in docs
#var recording  # See AudioStreamSample in docs
#
#var save_path = "res://recorded_audio.wav"
#
#var stereo := true
#var mix_rate := 44100  # This is the default mix rate on recordings
#var format := 1  # This equals to the default format: 16 bits
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	##connect("start_audio_recording", start_audio_recording)
	##connect("stop_audio_recording", stop_audio_recording)
	#var idx = AudioServer.get_bus_index("Record")
	#effect = AudioServer.get_bus_effect(idx, 0)
#
#func start_audio_recording():
	#stream = AudioStreamMicrophone.new()
	#play()
	##if !effect.is_recording_active():
		##effect.set_recording_active(true)
#
#func stop_audio_recording():
	#if effect.is_recording_active():
		#emit_signal("audio_recording_stopped")
		#recording = effect.get_recording()
		#effect.set_recording_active(false)
		#recording.set_mix_rate(mix_rate)
		#recording.set_format(format)
		#recording.set_stereo(stereo)
		#recording.save_to_wav(save_path)
		#print("Audio saved to: ", save_path)
		#LlmServer.send_audio("hi", "hi", save_path)
