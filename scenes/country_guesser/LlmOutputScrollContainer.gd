extends ScrollContainer

var max_height = 540  # Adjust this value to set the maximum height before scrolling

func _process(_delta):
	#var label = get_node("LlmOutputLabel")
	#label.text += "o " 
	self.scroll_vertical = self.get_v_scroll_bar().max_value
