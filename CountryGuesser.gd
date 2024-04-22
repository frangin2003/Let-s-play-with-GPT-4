extends Node2D

# useful for demo
#https://chat.openai.com/c/e3e218c3-d9ee-40fa-9fac-93cce48b936f
#https://chat.openai.com/c/29d08dfa-dab4-4b86-bce4-5ca259fc728f
#https://chat.openai.com/c/dd0866e0-cbdd-4360-80b6-90b5244d150e


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.SYSTEM = "Let's play a game. Think of a country and give me a clue. The clue must be specific enough that there is only one correct country. I will try pointing at the country on a map."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
