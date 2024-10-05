extends Node2D

@export var trash_scene: PackedScene  # Reference to the trash scene (e.g., TrashPlasticBottle.tscn)

func _ready():
	# Instantiate the trash scene
	var trash_instance = trash_scene.instantiate()
	
	# Add it to the current scene
	# add_child(trash_instance)
