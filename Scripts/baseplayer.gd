# PlayerBase.gd
class_name PlayerBase
extends CharacterBody2D

func _ready():
	add_to_group("player")

func get_facing() -> int:
	return 0  # overridden by each player
