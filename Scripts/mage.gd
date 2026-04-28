# Mage.gd
extends PlayerBase

@export var run_speed = 350
@export var jump_speed = -1000
@export var gravity = 2500

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('RArrow')
	var left = Input.is_action_pressed('LArrow')
	var jump = Input.is_action_just_pressed('UArrow')
	
	if is_on_floor() and jump:
		velocity.y = jump_speed
	if right:
		velocity.x += run_speed
		$MageSprite.scale.x = abs($MageSprite.scale.x)   # Face right
	if left:
		velocity.x -= run_speed
		$MageSprite.scale.x = -abs($MageSprite.scale.x)  # Face left (flipped)
		
func get_facing() -> int:
	return 1 if $MageSprite.scale.x > 0 else -1

func _physics_process(delta):
	velocity.y += gravity * delta
	get_input()
	move_and_slide()
