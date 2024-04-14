extends Node

var llm_inputs = []
var llm_chunks = []
signal llm_chunk(chunk)

var chat_socket = WebSocketPeer.new()
#var data_socket = WebSocketPeer.new()

func _ready():
	chat_socket.connect_to_url("ws://localhost:8765/chat")
	#data_socket.connect_to_url("ws://localhost:8765/data")

func _process(_delta):
	chat_socket.poll()
	var state = chat_socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while chat_socket.get_available_packet_count():
			var chunk = chat_socket.get_packet().get_string_from_utf8()
			print("Chunk: ", chunk)
			llm_chunks.append(chunk)
			emit_signal("llm_chunk", chunk)
				
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = chat_socket.get_close_code()
		var reason = chat_socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.

func get_json_text(system_message, user_message, audio_file_path = ""):
	var message_dict = {"system": system_message, "user": user_message, "audio_file_path": audio_file_path}
	llm_inputs.append(message_dict)
	return JSON.stringify(message_dict)

# Override _gui_input instead of _input for GUI elements like TextEdit.
func send_text(system_message, user_message):
	chat_socket.send_text(get_json_text(system_message, user_message))

# Not working for the moment, using file on disk
func send_audio(system_message, user_message, audio_file_path):
	chat_socket.send_text(get_json_text(system_message, user_message, audio_file_path))
#func send_audio(system_message, user_message, audio_bytes):
	#send_text(system_message, "")
	#data_socket.send(audio_bytes)
