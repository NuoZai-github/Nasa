extends AnimatedSprite2D

@export var pop_out_limit = 400.0  # The Y position where the beaker is considered "out of pop-out area"
var is_filled = false
var is_holding = false
var fill_time = 2.0  # Time player needs to hold to fill the beaker with water

func _ready():
	set_process_input(true)
	play("empty")  # Start with the empty beaker animation

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		# Get the size of the current frame in the animation
		var texture_size = sprite_frames.get_frame_texture(animation, 0).get_size()
		
		# Create a rectangle from the beaker's position and size
		var beaker_rect = Rect2(global_position - (texture_size / 2), texture_size)
		
		# Check if the mouse click is inside the beaker's rectangle
		if beaker_rect.has_point(event.position):
			is_holding = true

func _process(delta):
	if is_holding:
		fill_time -= delta
		if position.y < pop_out_limit and fill_time <= 0:  # Beaker is pulled out and hold time is complete
			if !is_filled:
				is_filled = true
				play("fill_beaker")  # Play the water filling animation
				is_holding = false
				print("Beaker filled with water")
		elif position.y >= pop_out_limit:
			is_holding = false  # If it's released back in the pop-out area, stop holding
