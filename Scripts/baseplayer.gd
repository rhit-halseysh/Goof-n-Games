# BasePlayer.gd
class_name BasePlayer
extends CharacterBody2D

func _ready():
	add_to_group("player")

func get_facing() -> int:
	return 0  # overridden by each player
	
func get_key_holder():
	pass # overridden
