extends Node2D

@export var trash_scene: PackedScene  # Reference to the trash scene (e.g., TrashPlasticBottle.tscn)

@onready var minigame_area = $MinigameArea  # Reference to the MinigameArea
@onready var button = $MinigameButton  # Reference to the Button node
@onready var plastic = $Plastic  # Reference to the Plastic node (Area2D)
@onready var can = $Can  # Reference to the Can node (Area2D)
@onready var bottle = $Bottle  # Reference to the Bottle node (Area2D)
@onready var timer_manager = $TimerManager  # Reference to the TimerManager (ensure this is correct)

func _ready():
	# Hide the minigame area initially
	minigame_area.visible = false

	# Connect the button press signal to the toggle function
	if not button.is_connected("pressed", Callable(self, "_on_minigame_button_pressed")):
		button.pressed.connect(Callable(self, "_on_minigame_button_pressed"))

# Function that triggers when the minigame button is pressed
func _on_minigame_button_pressed():
	# Toggle the MinigameArea visibility
	if minigame_area.visible:
		_on_close_popup_button_pressed()  # Call the close function to hide it
	else:
		_open_minigame_area()  # Open the MinigameArea

# Function to show the MinigameArea
func _open_minigame_area():
	minigame_area.visible = true  # Show the MinigameArea
	print("Minigame panel shown")

# Function to hide the MinigameArea
func _on_close_popup_button_pressed():
	minigame_area.visible = false  # Hide the MinigameArea
	print("Minigame panel hidden")

# Input event handler for the Plastic node
func _on_Plastic_input_event(viewport, event, shape_idx):
	if minigame_area.visible:
		# Ignore input if MinigameArea is open
		return
	# Handle input for the plastic node when MinigameArea is closed
	print("Plastic clicked!")
	# Example: Add 5 seconds to the timer when Plastic is clicked
	timer_manager.add_time(5)

# Input event handler for the Can node
func _on_Can_input_event(viewport, event, shape_idx):
	if minigame_area.visible:
		# Ignore input if MinigameArea is open
		return
	# Handle input for the can node when MinigameArea is closed
	print("Can clicked!")
	timer_manager.add_time(5)

# Input event handler for the Bottle node
func _on_Bottle_input_event(viewport, event, shape_idx):
	if minigame_area.visible:
		# Ignore input if MinigameArea is open
		return
	# Handle input for the bottle node when MinigameArea is closed
	print("Bottle clicked!")
	timer_manager.add_time(5)
