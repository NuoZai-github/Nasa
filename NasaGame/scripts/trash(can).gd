extends Area2D

# Scene movement variables
@export var speed: float = 280.0
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

# Process function for movement (called every frame)
func _process(delta: float) -> void:
	position.x -= speed * delta

	# If the node reaches the left limit, reset to the right side
	if position.x < left_limit:
		timer_manager.decrease_time(5)
		respawn()

# Handle input event on the collision shape
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		handle_press()

# Function to handle what happens when the scene is pressed
func handle_press() -> void:
	timer_manager.add_time(5)  # Increase the timer by 5 seconds
	respawn()  # Move the scene back to the right side

# Function to respawn the scene on the right with a random Y position
func respawn() -> void:
	position.x = right_limit  # Reset to the right side
	position.y = randf_range(min_y, max_y)  # Randomize the Y position within the new range
