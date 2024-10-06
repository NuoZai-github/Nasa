extends Control  # MinigameArea is a Control node

# Update the node paths to reflect the correct names
@onready var beaker = $Panel/Beaker  # Reference to the Beaker node
@onready var salt = $Panel/Salt  # Reference to the Salt node
@onready var ph_paper = $Panel/"Ph paper"  # Reference to the Ph paper node

var dragged_node = null  # This will hold the node that is being dragged
var offset = Vector2.ZERO  # To keep track of the offset when dragging

# Screen or area size (define the boundaries for dragging)
var min_x = 0  # Left boundary
var max_x = 1024  # Right boundary (set according to your window or MinigameArea size)
var min_y = 0  # Top boundary
var max_y = 768  # Bottom boundary (set according to your window or MinigameArea size)

# Enable input processing for dragging
func _ready():
	# Verify if nodes are loaded properly
	if !beaker or !salt or !ph_paper:
		print("One or more nodes are missing. Please check the node paths.")
		return
	set_process_input(true)

# Detect when mouse is pressed and released for dragging
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			# Check if the mouse is pressed on one of the draggable items
			if beaker.get_global_mouse_position().distance_to(beaker.global_position) < 50:
				dragged_node = beaker
				offset = beaker.position - get_local_mouse_position()  # Calculate local offset
			elif salt.get_global_mouse_position().distance_to(salt.global_position) < 50:
				dragged_node = salt
				offset = salt.position - get_local_mouse_position()  # Calculate local offset
			elif ph_paper.get_global_mouse_position().distance_to(ph_paper.global_position) < 50:
				dragged_node = ph_paper
				offset = ph_paper.position - get_local_mouse_position()  # Calculate local offset

		elif not event.pressed:
			dragged_node = null  # Stop dragging when mouse is released

# Move the dragged node with the mouse
func _process(delta):
	if dragged_node:
		# Update position of the dragged node with the local mouse position and the correct offset
		dragged_node.position = get_local_mouse_position() + offset  # Apply the correct offset

		# Constrain position within the screen or defined boundaries
		dragged_node.position.x = clamp(dragged_node.position.x, min_x, max_x)
		dragged_node.position.y = clamp(dragged_node.position.y, min_y, max_y)
