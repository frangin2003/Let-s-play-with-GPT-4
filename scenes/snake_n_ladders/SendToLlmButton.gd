extends Button

signal audio_recording_started
signal audio_recording_stopped

var llmOutput

var PRESS_TO_RECORD = "PRESS TO RECORD"
var STOP_RECORDING_AND_SEND = "STOP RECORDING AND SEND"

var llmOutputLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	llmOutputLabel = get_node("../LlmOutputControl/LlmOutputScrollContainer/LlmOutputLabel")
	text = PRESS_TO_RECORD

func _on_Button_pressed():
	if text == PRESS_TO_RECORD:
		Global.resetAudioAndScreenshot()
		emit_signal("audio_recording_started")
		text = STOP_RECORDING_AND_SEND
	else:
		emit_signal("audio_recording_stopped")
		save_cropped_screenshot_and_animate()
		text = PRESS_TO_RECORD

func save_cropped_screenshot_and_animate():
	var root_node = get_tree().get_root().get_child(0)
	var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var cropped_width = int(screen_width * 0.685)

	var viewport = root_node.get_viewport()
	var full_texture = viewport.get_texture()
	var full_image = full_texture.get_image()
	await get_tree().process_frame # Ensure the image is ready

	var cropped_image = Image.create(cropped_width, screen_height, false, full_image.get_format())
	var src_rect = Rect2(0, 0, cropped_width, screen_height)
	var dst_pos = Vector2.ZERO
	cropped_image.blit_rect(full_image, src_rect, dst_pos)
	
	# Save to Global var
	Global.SCREENSHOT = cropped_image.save_png_to_buffer()

	# Save the cropped image to disk
	print(Global.SCREENSHOT_URL)
	var save_error = cropped_image.save_png(Global.SCREENSHOT_URL)
	if save_error != OK:
		push_error("Failed to save screenshot: " + str(save_error))
	else:
		print("Screenshot saved as: " + Global.SCREENSHOT_URL)

	var image_texture = ImageTexture.create_from_image(cropped_image)

	# Setup TextureRect to show the screenshot
	var texture_rect = TextureRect.new()
	texture_rect.texture = image_texture
	texture_rect.size = Vector2(cropped_width, screen_height)

	var control_node = Control.new()
	control_node.add_child(texture_rect)
	add_child(control_node)
	
	# Ensure the screenshot is always on top
	control_node.set_as_top_level(true)

	# Start animation
	var tween = create_tween()
	var start_pos = Vector2(0, screen_height / 2 - texture_rect.size.y / 2)
	var end_pos = global_position + size - Vector2(50, 50)
	end_pos.x = end_pos.x * 0.85
	var end_scale = Vector2(0.1, 0.1) # Small scale at the end

	texture_rect.global_position = start_pos

	tween.tween_property(texture_rect, "global_position", end_pos, 0.8)
	tween.parallel().tween_property(texture_rect, "scale", end_scale, 0.8)
	await tween.finished

	control_node.queue_free()
	var user_text = get_node("../UserTextEdit").text
	get_node("../UserTextEdit").text = ""
	llmOutputLabel.text += "\n\n[Jay Petey]: "
	LlmServer.send_to_llm_server(Global.SYSTEM, user_text, false, Global.SCREENSHOT_URL, Global.SYSTEM_IMAGE_URL)

