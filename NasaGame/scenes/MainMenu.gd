extends Control

func _on_start_game_pressed():
	# Play the click sound
	$ClickSoundPlayer.play()
	
	# Load the game scene as a PackedScene and change to it
	var game_scene = load("res://scenes/game.tscn") as PackedScene
	if game_scene != null:
		get_tree().change_scene_to_packed(game_scene)

func _on_quit_pressed():
	# Play the click sound
	$ClickSoundPlayer.play()

	# Quit the game after a slight delay to allow the click sound to play
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()

func _ready():
	$VBoxContainer/Start.connect("pressed", Callable(self, "_on_start_game_pressed"))
	$VBoxContainer/Quit.connect("pressed", Callable(self, "_on_quit_pressed"))
	
	# Start the background music
	$"Background music".stream.loop = true
	$"Background music".play()
