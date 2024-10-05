extends Node2D

# Scene movement variables
@export var speed: float = 250.0
@export var left_limit: float = -500.0
@export var right_limit: float = 500.0
@export var min_y: float = -120.0  # Set minimum Y to -120px
@export var max_y: float = 120.0   # Set maximum Y to 120px
@export var size: Vector2 = Vector2(100, 100)  # Example size (width and height)

# Reference to the TimerManager node (adjust the path as necessary)
@onready var timer_manager = get_parent().get_node("TimerManager")  # Adjust path

# Called when the node is ready
func _ready() -> void:
	print_tree()
	# Allow detection of mouse input on this node
	set_process_input(true)

# Process function for movement (called every frame)
func _process(delta: float) -> void:
	position.x -= speed * delta

	# If the node reaches the left limit, reset to the right side
	if position.x < left_limit:
		respawn()

# Handle input to detect if the node is pressed (scene interaction)
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		# Get the global mouse position
		var mouse_pos = get_global_mouse_position()
		# Create a Rect2 based on the node's position and size
		var node_rect = Rect2(global_position - size / 2, size)
		# Check if the mouse is within the node's Rect2
		if node_rect.has_point(mouse_pos):
			handle_press()

# Function to handle what happens when the scene is pressed
func handle_press() -> void:
	timer_manager.add_time(5)  # Increase the timer by 5 seconds
	respawn()  # Move the scene back to the right side

# Function to respawn the scene on the right with a random Y position
func respawn() -> void:
	position.x = right_limit  # Reset to the right side
	position.y = randf_range(min_y, max_y)  # Randomize the Y position within the new range
