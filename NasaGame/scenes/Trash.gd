extends Sprite2D

# Signal emitted when the trash is removed
signal trash_removed

# Speed of the trash object movement
@export var move_speed: float = 100.0

# Horizontal boundary where the trash gets removed
@export var boundary_x: float = 1024.0

# Called when the object is ready (spawning)
func _ready() -> void:
	randomize()  # Randomize the seed to ensure different results each run

	# Set a random position on the screen (adjust ranges based on your screen setup)
	position = Vector2(randi_range(0, boundary_x), randi_range(200, 500))

	# Enable the physics process to move the trash across the screen
	set_physics_process(true)

# Called every frame to handle movement
func _physics_process(delta: float) -> void:
	# Move the trash from left to right or adjust based on your game direction
	position.x += move_speed * delta
	
	# If the trash moves out of bounds, remove it
	if position.x > boundary_x:
		queue_free()  # Remove the trash if it leaves the screen

# Detect when the player clicks/taps the trash
func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed:
		# Emit signal to notify the game that the trash is removed
		emit_signal("trash_removed", self)
		
		# Remove the trash object from the scene
		queue_free()
