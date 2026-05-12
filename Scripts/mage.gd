# Warrior.gd
extends BasePlayer

func get_input(delta: float):
	var grounded = is_on_floor()
	var horizontal = Input.get_axis('LArrow', 'RArrow')
	
	if on_ladder:
		var vertical = Input.get_axis('UArrow', 'DArrow')
		if vertical:
			velocity.y = vertical * CLIMB_SPEED
			climbing = not grounded
		else:
			velocity.y = move_toward(velocity.y, 0, CLIMB_SPEED)
			if grounded: climbing = false
		#if climbing:
			#if vertical: animation
			#else: stop animation
	elif not grounded:
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed('UArrow') and not climbing and grounded:
		velocity.y = jump_speed
		
	if horizontal:
		$MageSprite.flip_h = velocity.x < 0
		velocity.x = horizontal * run_speed
		if on_ladder: climbing = not grounded
		else: climbing = false
	else: 
		velocity.x = move_toward(velocity.x, 0, run_speed)
		#if not climbing: anim.play('idle')

func get_facing() -> int:
	return 1 if $MageSprite.scale.x < 0 else -1
	
func get_key_holder() -> Node:
	return $MageKeyHolder
	
func _physics_process(delta):
	get_input(delta)
	move_and_slide()

func _on_ladder_detector_body_entered(body: Node2D) -> void:
	on_ladder = true

func _on_ladder_detector_body_exited(body: Node2D) -> void:
	on_ladder = false
