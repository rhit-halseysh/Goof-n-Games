extends Area2D

@export var open_speed := 200.0     # pixels per second the door slides open
@export var open_direction := Vector2.UP   # which way the door moves when open

var _key: Node2D = null
var _unlocked := false
var _opening := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if _opening:
		position += open_direction * open_speed * delta

## Called by the key once it arrives.
func unlock() -> void:
	_unlocked = true
	_opening  = true
	# Optional: play an animation, sound, particles here
	print("Door unlocked!")
	await get_tree().create_timer(1.0).timeout   # let the door animate briefly
	SceneManager.goto_scene()

func _on_body_entered(body: Node) -> void:
	if _unlocked or not body.is_in_group("player"):
		return

	# Does this player carry the key?
	var key := _find_key_on(body)
	if key:
		key.start_unlock(self)

func _find_key_on(player: Node) -> Node:
	# The key tracks the player reference — check all FloatingKey nodes in the scene
	for key in get_tree().get_nodes_in_group("floating_key"):
		if key.player == player and key.state == FloatingKey.State.FOLLOWING:
			return key
	return null
