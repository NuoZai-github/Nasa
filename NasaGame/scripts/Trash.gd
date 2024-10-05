extends Node2D

# Speed of movement
@export var speed: float = 80.0
# Left boundary where the scene resets
@export var left_limit: float = -500.0
# Right boundary where the scene starts again
@export var right_limit: float = 500.0

func _process(delta: float) -> void:
	# Move the node to the left
	position.x -= speed * delta

	# If the node goes past the left limit, reset its position to the right limit
	if position.x < left_limit:
		position.x = right_limit
