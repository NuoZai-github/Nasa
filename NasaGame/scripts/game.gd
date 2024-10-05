extends Node2D

@export var trash_scene: PackedScene  # Reference to the trash scene (e.g., TrashPlasticBottle.tscn)
# minigame_scene is not needed if MinigameArea is directly used as the minigame

@onready var minigame_area = $MinigameArea  # Reference to the Panel node (MinigameArea)
@onready var button = $MinigameButton  # Reference to the Button node

func _ready():

	# Hide the minigame area initially
	minigame_area.visible = false

	# Check if the signal is already connected before connecting it
	if not button.is_connected("pressed", Callable(self, "_on_minigame_button_pressed")):
		button.pressed.connect(Callable(self, "_on_minigame_button_pressed"))

# Function that triggers when the minigame button is pressed
func _on_minigame_button_pressed():
	# Show the MinigameArea with half-transparent background
	minigame_area.visible = true
	print("Minigame panel shown")

# Function to hide the MinigameArea
func _on_close_popup_button_pressed():
	minigame_area.visible = false  # Hide the minigame area
	print("Minigame panel hidden")
