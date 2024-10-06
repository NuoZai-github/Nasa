extends Node

# Time remaining variable
var time_left: int = 60  # Total time in seconds

# References to the Timer and Label nodes
@onready var timer = $Timer  # Reference to the Timer node
@onready var countdown_label = $CountdownLabel  # Reference to the Label node

# Called when the node is ready
func _ready() -> void:
	update_label()  # Display the initial time (60 seconds)
	
	timer.wait_time = 1.0  # The timer will tick every second
	timer.start()  # Start the timer
	timer.timeout.connect(_on_Timer_timeout)  # Connect the timeout signal

# Called when the timer times out (every second)
func _on_Timer_timeout() -> void:
	if time_left > 0:
		time_left -= 1  # Reduce time left by 1 second
		update_label()  # Update the label with the new time
		print("Time left: ", time_left)  # Debugging print statement to check time progression
	else:
		end_game()  # End the game when time runs out

# Function to handle adding extra time when a successful action occurs
func add_time(seconds: int) -> void:
	time_left += seconds  # Add bonus time
	update_label()  # Update the label with the new time

func decrease_time(amount: int) -> void:
	time_left -= amount
	if time_left < 0:
		time_left = 0
	print("Time decreased, new time:", time_left)

# Function to update the countdown label text
func update_label() -> void:
	countdown_label.text = "Time Left: " + str(time_left)  # Display the remaining time

# Function to handle end-of-game logic
func end_game() -> void:
	timer.stop()  # Stop the timer
	countdown_label.text = "Game Over!"  # Update the label to show "Game Over"
	print("Game Over!")
	# Quit the game after a slight delay to allow the click sound to play
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
