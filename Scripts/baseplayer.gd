# BasePlayer.gd
class_name BasePlayer
extends CharacterBody2D

@export var run_speed = 350
@export var jump_speed = -500
@export var gravity = 2500
@export var health = 0
@export var CLIMB_SPEED = 200.0

var on_ladder: bool
var climbing: bool

func _ready():
	add_to_group("player")

func get_facing() -> int:
	return 0  # overridden by each player
	
func get_key_holder():
	pass # overridden
	
