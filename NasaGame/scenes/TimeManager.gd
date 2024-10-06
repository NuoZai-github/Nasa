extends Node

var time_left: int = 300  # Default starting time, adjust this as needed

# Function to get the remaining time
func get_remaining_time() -> int:
	return time_left

# Function to reset the timer back to the default value
func reset_time():
	time_left = 300  # Reset to 300 seconds, or whatever your default value is
	print("Time reset to:", time_left)

# You can add a function to decrease the time if needed
func decrease_time(amount: int) -> void:
	time_left -= amount
	if time_left < 0:
		time_left = 0
	print("Time decreased, new time:", time_left)
