extends Button

signal audio_recording_started
signal audio_recording_stopped

var llmOutput

var PRESS_TO_RECORD = "PRESS TO RECORD"
var STOP_RECORDING_AND_SEND = "STOP RECORDING AND SEND"


# Called when the node enters the scene tree for the first time.
func _ready():
	#LlmServer.connect("llm_chunk", llm_chunk)
	#connect("pressed", _on_Button_pressed)
	text = PRESS_TO_RECORD
#
func _on_Button_pressed():
	if text == PRESS_TO_RECORD:
		emit_signal("audio_recording_started")
		text = STOP_RECORDING_AND_SEND
	else:
		emit_signal("audio_recording_stopped")
		text = PRESS_TO_RECORD
#
#func _process(delta):
	#pass
#
#func llm_chunk(chunk):
	#if (chunk == "<|im_end|>"):
		#get_node("../RecordVoiceButton").visible = true
	#if (chunk != "<|im_start|>" and chunk != "<|im_end|>"):
		#gameMasterOutput.text += chunk
	#if "Not very polite" in gameMasterOutput.text :
		#get_tree().change_scene_to_file("res://scenes/xx_pig/xx_pig.tscn")
	#if "Ok, you are forgiven." in gameMasterOutput.text :
		#get_tree().change_scene_to_file("res://scenes/" + Global.SCENE + "/" + Global.SCENE + ".tscn")
#
## Override _gui_input instead of _input for GUI elements like TextEdit.
#func _gui_input(event):
	#if event is Input:
		#var key_event = event as InputEventKey
		#if key_event.pressed and key_event.keycode == KEY_ENTER:
			#var user_message = text # Get the text from the TextEdit
			#var system_message = Global.INSTRUCTIONS
			#get_node("../RecordVoiceButton").visible = false
			#clear()
			#gameMasterOutput.text = ""
			#LlmServer.send_text(system_message, user_message)
			#get_viewport().set_input_as_handled()
			
