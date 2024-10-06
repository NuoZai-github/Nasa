extends Control

func _on_start_game_pressed():
	# Load the game scene as a PackedScene and change to it
	var game_scene = load("res://scenes/game.tscn") as PackedScene
	if game_scene != null:
		get_tree().change_scene_to_packed(game_scene)

func _on_quit_pressed():
	# Quit the game
	get_tree().quit()

# Connect buttons in the _ready() function
func _ready():
	$VBoxContainer/Start.connect("pressed", Callable(self, "_on_start_game_pressed"))
	$VBoxContainer/Quit.connect("pressed", Callable(self, "_on_quit_pressed"))
