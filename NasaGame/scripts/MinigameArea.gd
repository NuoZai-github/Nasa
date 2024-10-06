extends Control  # Since MinigameArea is a Control node

# Export PackedScene variables to load the separate scenes
@export var beaker_scene: PackedScene
@export var salt_crystal_scene: PackedScene
@export var ph_paper_scene: PackedScene

# References to the instances of the draggable items
var beaker = null
var salt_crystal = null
var ph_paper = null

var dragged_node = null  # This will hold the node that is being dragged by the mouse

func _ready():
	set_process_input(true)  # Enable input processing
	instantiate_minigame_items()  # Instantiate and add the minigame items

# Function to dynamically load and instantiate the beaker, salt crystal, and pH paper
func instantiate_minigame_items():
	# Load and instance the Beaker scene
	if beaker_scene:
		beaker = beaker_scene.instantiate()
		$Panel.add_child(beaker)  # Add the beaker to the Panel node
		beaker.rect_position = Vector2(100, 100)  # Set position (adjust as needed)

	# Load and instance the Salt Crystal scene
	if salt_crystal_scene:
		salt_crystal = salt_crystal_scene.instantiate()
		$Panel.add_child(salt_crystal)  # Add the salt crystal to the Panel node
		salt_crystal.rect_position = Vector2(200, 100)  # Set position (adjust as needed)

	# Load and instance the Ph Paper scene
	if ph_paper_scene:
		ph_paper = ph_paper_scene.instantiate()
		$Panel.add_child(ph_paper)  # Add the pH paper to the Panel node
		ph_paper.rect_position = Vector2(300, 100)  # Set position (adjust as needed)

# Function to open the MinigameArea and pause the MainScene
func open_minigame():
	get_tree().paused = true  # Pause the MainScene
	self.visible = true  # Show the MinigameArea

# Function to close the MinigameArea and unpause the MainScene
func close_minigame():
	get_tree().paused = false  # Unpause the MainScene
	self.visible = false  # Hide the MinigameArea

# Handle mouse input for dragging objects
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		# Check if the mouse is pressed on one of the draggable items
		if beaker and beaker.get_global_rect().has_point(event.position):
			dragged_node = beaker
		elif salt_crystal and salt_crystal.get_global_rect().has_point(event.position):
			dragged_node = salt_crystal
		elif ph_paper and ph_paper.get_global_rect().has_point(event.position):
			dragged_node = ph_paper

	# If the mouse button is released, stop dragging
	if event is InputEventMouseButton and not event.pressed:
		dragged_node = null

# Update the position of the dragged object (if any)
func _process(delta):
	if dragged_node:
		# Since it's a Control node, use `rect_position` to move the dragged node
		dragged_node.rect_position = get_global_mouse_position() - dragged_node.rect_size / 2
