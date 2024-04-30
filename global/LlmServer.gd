extends Node

signal llm_chunk(chunk)

var socket = WebSocketPeer.new()

func _ready():
	socket.connect_to_url("ws://localhost:8765")

func _process(_delta):
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var chunk = socket.get_packet().get_string_from_utf8()
			print("Chunk: ", chunk)
			emit_signal("llm_chunk", chunk)
				
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.

func create_message(role, prompt, image_url=null, with_speech: bool=false):
	var message_dict = {}
	if (not with_speech or image_url == null):
		message_dict = {"role": role, "content": prompt}
	else:
		var content_array = []
		
		if (prompt != null):
			content_array.append({
				"type": "text",
				"text": prompt
			})
		
		if (with_speech):
			content_array.append({
				"type": "speech_url",
				"speech_url": {"url": Global.RECORDED_AUDIO_URL}
			})
		
		if (image_url != null):
			content_array.append({
				"type": "image_url",
				"image_url": {"url": image_url}
			})
		
		message_dict = {"role": role, "content": content_array}
	
	Global.add_to_memory(message_dict)
	return message_dict

func send_text(content: Dictionary) -> void:
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		socket.send_text(JSON.stringify(content))
	else:
		print("WebSocket is not connected.")

func send_to_llm_server(system_prompt: String, user_prompt: String, image_url: String, with_speech: bool) -> void:
	Global.LLM_INPUT_ARRAY.append(create_message("system", system_prompt))
	Global.LLM_INPUT_ARRAY.append(create_message("user", user_prompt, image_url, with_speech))
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		socket.send_text(JSON.stringify({"messages": Global.LLM_INPUT_ARRAY}))
	else:
		print("WebSocket is not connected.")

#func send_system_and_voice_prompt(system_prompt: String, voice_data: PackedByteArray) -> void:
	#var base64_voice = Marshalls.raw_to_base64(voice_data)
	#var message = {
		#"messages": [
			#{"role": "system", "content": system_prompt},
			#{"role": "user", "content": [{"type": "voice", "voice": {"data": base64_voice}}]}
		#]
	#}
	#send_text(message)
#
#func send_system_and_images_and_user_prompt(system_prompt: String, user_prompt: String, image_data_array: Array) -> void:
	#var image_content = []
	#for data in image_data_array:
		#var base64_image = Marshalls.raw_to_base64(data)
		#image_content.append({"type": "image", "image": {"data": base64_image}})
	#var message = {
		#"messages": [
			#{"role": "system", "content": system_prompt},
			#{"role": "user", "content": [{"type": "text", "text": user_prompt}] + image_content}
		#]
	#}
	#send_text(message)
#
#func send_system_and_one_image_and_voice_prompt(system_prompt: String, voice_data: PackedByteArray, image_data: PackedByteArray) -> void:
	#var base64_voice = Marshalls.raw_to_base64(voice_data)
	#var image_content = []
	#var base64_image = Marshalls.raw_to_base64(image_data)
	#image_content.append({"type": "image", "image": {"data": base64_image}})
	#var message = {
		#"messages": [
			#{"role": "system", "content": system_prompt},
			#{"role": "user", "content": [{"type": "voice", "voice": {"data": base64_voice}}] + image_content}
		#]
	#}
	#send_text(message)
#
#func send_system_and_one_image_and_voice_prompt_urls(system_prompt: String, voice_url: String, image_url: String) -> void:
	#var image_content = []
	#image_content.append({"type": "image", "image": {"url": image_url}})
	#var message = {
		#"messages": [
			#{"role": "system", "content": system_prompt},
			#{"role": "user", "content": [{"type": "voice", "voice": {"url": voice_url}}] + image_content}
		#]
	#}
	#send_text(message)
#
#func send_system_and_images_and_voice_prompt(system_prompt: String, voice_data: PackedByteArray, image_data_array: Array) -> void:
	#var base64_voice = Marshalls.raw_to_base64(voice_data)
	#var image_content = []
	#for data in image_data_array:
		#var base64_image = Marshalls.raw_to_base64(data)
		#image_content.append({"type": "image", "image": {"data": base64_image}})
	#var message = {
		#"messages": [
			#{"role": "system", "content": system_prompt},
			#{"role": "user", "content": [{"type": "voice", "voice": {"data": base64_voice}}] + image_content}
		#]
	#}
	#send_text(message)
