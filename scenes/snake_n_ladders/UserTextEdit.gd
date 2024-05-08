extends TextEdit

var llmOutputLabel
var BEGIN_OF_TEXT_TAG = "<|begin_of_text|>"
var END_OF_TEXT_TAG = "<|end_of_text|>"
var COMMAND_TAG = "<|command|>"
var output = ""
var command = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	LlmServer.connect("llm_chunk", llm_chunk)
	llmOutputLabel = get_node("../LlmOutputControl/LlmOutputScrollContainer/LlmOutputLabel")
	grab_focus()
	print("READY")

func _process(delta):
	pass

func llm_chunk(chunk):
	output += chunk
	if (chunk == END_OF_TEXT_TAG):
		Global.add_to_memory(LlmServer.create_assistant_message(output))
	if (chunk != BEGIN_OF_TEXT_TAG
		and chunk != END_OF_TEXT_TAG
		and !chunk.begins_with(COMMAND_TAG)):
		llmOutputLabel.text += chunk
	if (chunk.begins_with(COMMAND_TAG)):
		command = chunk.substr(COMMAND_TAG.length(), chunk.length() - COMMAND_TAG.length())

# Override _gui_input instead of _input for GUI elements like TextEdit.
func _gui_input(event):
	if event is InputEventKey:
		var key_event = event as InputEventKey
		if key_event.pressed and key_event.keycode == KEY_ENTER:
			var user_message = text # Get the text from the TextEdit
			clear()
			llmOutputLabel.text += "\n\n[You]: " + user_message
			llmOutputLabel.text += "\n\n[Jay Petey]: "
			output = ""
			command = ""
			LlmServer.send_to_llm_server(Global.SYSTEM, user_message)
			get_viewport().set_input_as_handled()
			
