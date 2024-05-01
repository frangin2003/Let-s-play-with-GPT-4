extends AudioStreamPlayer

var effect  # See AudioEffect in docs
var recording  # See AudioStreamSample in docs
var stereo := true
var mix_rate := 44100  # This is the default mix rate on recordings
var format := 1  # This equals to the default format: 16 bits

# Called when the node enters the scene tree for the first time.
func _ready():
	var idx = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(idx, 0)

func start_audio_recording():
	if !effect.is_recording_active():
		effect.set_recording_active(true)

func stop_audio_recording():
	if effect.is_recording_active():
		recording = effect.get_recording()
		effect.set_recording_active(false)
		recording.set_mix_rate(mix_rate)
		recording.set_format(format)
		recording.set_stereo(stereo)
				
		Global.RECORDED_AUDIO = recording.data
		recording.save_to_wav(Global.RECORDED_AUDIO_URL)
		print("Audio NOT saved to: ", Global.RECORDED_AUDIO_URL)
