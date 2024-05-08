extends Area2D

var grabbed = false
var mouse_offset = Vector2.ZERO

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Start grabbing the sprite
			grabbed = true
			mouse_offset = position - get_global_mouse_position()
		else:
			# Release the sprite
			grabbed = false

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		# Release the sprite
		grabbed = false

func _process(_delta):
	if grabbed:
		# Update the sprite's position to follow the mouse
		position = get_global_mouse_position() + mouse_offset
