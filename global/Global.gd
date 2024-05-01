extends Node

var RECORDED_AUDIO: PackedByteArray
var SCREENSHOT: PackedByteArray

var LLM_INPUT_ARRAY = []
var RECORDED_AUDIO_URL = ProjectSettings.globalize_path("res://") + "recorded_audio.wav"
var SCREENSHOT_URL = ProjectSettings.globalize_path("res://") + "screenshot.png"
var SYSTEM = null
var SYSTEM_IMAGE_URL = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func resetAudioAndScreenshot():
	RECORDED_AUDIO = PackedByteArray()
	SCREENSHOT = PackedByteArray()

func add_to_memory(message):
	LLM_INPUT_ARRAY.append(message)

func reset_memory():
	LLM_INPUT_ARRAY = []

func check_and_send_to_llm_urls():
	if RECORDED_AUDIO != null and SCREENSHOT != null:
		print("Audio recording and screenshot are ready!")
		LlmServer.send_to_llm_server(SYSTEM, "Look closely at the tip of your index finger on the map. Verify thoroughly that you are pointing at the correct country based on the clue provided.", false, SCREENSHOT_URL, SYSTEM_IMAGE_URL)

# Called when the node enters the scene tree for the first time.
func _ready():
	resetAudioAndScreenshot()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
