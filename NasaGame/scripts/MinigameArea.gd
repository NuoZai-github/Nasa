extends Control  # MinigameArea is a Control node

# Update the node paths to reflect the correct names
@onready var beaker = $Panel/Beaker  # Reference to the Beaker node
@onready var salt = $Panel/Salt  # Reference to the Salt node
@onready var ph_paper = $Panel/"Ph paper"  # Reference to the Ph paper node
@onready var ph_result_label = $PhResultLabel  # Reference to the Label for showing pH result
@onready var time_manager = $TimeManager  # Reference to the TimeManager
@onready var popup_timer = $PopupTimer  # Reference to the PopupTimer node for auto-closing

var dragged_node = null  # This will hold the node that is being dragged
var offset = Vector2.ZERO  # To keep track of the offset when dragging

# Screen or area size (define the boundaries for dragging)
var min_x = 0  # Left boundary
var max_x = 1024  # Right boundary (set according to your window or MinigameArea size)
var min_y = 0  # Top boundary
var max_y = 768  # Bottom boundary (set according to your window or MinigameArea size)

var stick_timer: Timer = null  # This will hold our dynamically created timer
var stick_duration = 3.0  # How long they need to stay close to show the result
var are_stuck = false

# Enable input processing for dragging
func _ready():
	# Verify if nodes are loaded properly
	if !beaker or !salt or !ph_paper or !ph_result_label or !time_manager or !popup_timer:
		print("One or more nodes are missing. Please check the node paths.")
		return

	# Initialize result label as hidden
	ph_result_label.visible = false

	# Create a new Timer and add it to the scene for item-sticking detection
	stick_timer = Timer.new()  # Create a new Timer instance
	stick_timer.wait_time = stick_duration  # Set the wait time for 3 seconds
	stick_timer.one_shot = true  # Ensure it's one shot
	add_child(stick_timer)  # Add the timer to the scene

	# Connect the timeout signal to a function that handles what happens after 3 seconds
	stick_timer.timeout.connect(Callable(self, "_on_stick_timer_timeout"))

	# Connect popup_timer to auto-close the pop-up after the timer finishes
	popup_timer.connect("timeout", Callable(self, "_close_popup"))

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

	# Check if Beaker, Salt, and Ph paper are close together
	if are_items_stuck():
		if !are_stuck:  # If they just got stuck, start the timer
			print("Items are close, starting the timer.")
			stick_timer.start()  # Start the timer if items are stuck
			are_stuck = true
		elif stick_timer.is_stopped():
			# If the timer completes, show the pH result
			show_ph_result()
	else:
		# If they move apart, reset the state and stop the timer
		if are_stuck:
			print("Items moved apart, stopping the timer.")
			stick_timer.stop()  # Stop the timer if items move apart
			are_stuck = false

# Check if Beaker, Salt, and Ph paper are within a small distance of each other
func are_items_stuck() -> bool:
	var beaker_pos = beaker.global_position
	var salt_pos = salt.global_position
	var ph_paper_pos = ph_paper.global_position

	var distance_threshold = 50.0  # You can adjust this value
	return (beaker_pos.distance_to(salt_pos) < distance_threshold and
			beaker_pos.distance_to(ph_paper_pos) < distance_threshold and
			salt_pos.distance_to(ph_paper_pos) < distance_threshold)

# Function to handle the timeout signal
func _on_stick_timer_timeout():
	print("Timer finished!")
	show_ph_result()  # Call the function to display the pH result

# Function to calculate and display the pH result
func show_ph_result():
	var remaining_time = time_manager.get_remaining_time()  # Get remaining time from TimeManager

	var ph_result: String

	# Logic based on time conditions
	if remaining_time > 200:
		ph_result = "Neutral"
	elif remaining_time > 100 and remaining_time <= 200:
		ph_result = "Alkaline"
	else:
		ph_result = "Acid"

	# Display the pH result in the label
	ph_result_label.text = "pH Result: " + ph_result
	ph_result_label.visible = true  # Make the label visible
	print("pH result: " + ph_result)  # Output to console (optional)

	# Start the popup timer to close after 2.5 seconds
	print("Starting popup timer for 2.5 seconds")
	popup_timer.start(2.5)  # Auto-close after 2.5 seconds

# Function to close the pop-up and reset the minigame
func _close_popup():
	print("Auto-closing the popup and resetting the game.")
	
	# Hide the pop-up and reset components
	ph_result_label.visible = false  # Hide the result label

	# Reset draggable items to their original positions (adjust the positions as needed)
	beaker.position = Vector2(200, 300)
	salt.position = Vector2(400, 300)
	ph_paper.position = Vector2(600, 300)

	# Reset the timer
	time_manager.reset_time()  # This now works as the reset_time function is defined in TimeManager

	# Hide the MinigameArea (if you're using a panel to show/hide the minigame)
	self.visible = false
