extends Node

var RECORDED_AUDIO: PackedByteArray
var SCREENSHOT: PackedByteArray

var RECORDED_AUDIO_URL = null
var SCREENSHOT_URL = null
var SYSTEM = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func resetAudioAndScreenshot():
	RECORDED_AUDIO = PackedByteArray()
	SCREENSHOT = PackedByteArray()
	RECORDED_AUDIO_URL = null
	SCREENSHOT_URL = null

func check_and_send_to_llm():
	if RECORDED_AUDIO != null and SCREENSHOT != null:
		print("Audio recording and screenshot are ready!")
		LlmServer.send_system_and_one_image_and_voice_prompt(SYSTEM, RECORDED_AUDIO, SCREENSHOT)

func check_and_send_to_llm_urls():
	if RECORDED_AUDIO_URL != null and SCREENSHOT_URL != null:
		print("Audio recording and screenshot are ready!")
		LlmServer.send_system_and_one_image_and_voice_prompt_urls(SYSTEM, RECORDED_AUDIO_URL, SCREENSHOT_URL)

# Called when the node enters the scene tree for the first time.
func _ready():
	resetAudioAndScreenshot()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
