class_name FloatingKey

extends Area2D

enum State { FLOATING, FOLLOWING, UNLOCKING }

@export var float_amplitude := 8.0       # pixels up/down while idle
@export var float_speed := 2.0           # idle bob frequency
@export var follow_distance := 60.0      # how far behind the player it trails
@export var follow_speed := 5.0          # lerp speed when following
@export var unlock_speed := 300.0        # px/s when flying to door

var state := State.FLOATING
var player: Node2D = null
var door: Node2D = null
var origin: Vector2                      # spawn position for idle bob

func _ready() -> void:
	origin = global_position
	# Listen for a player walking into the key's pickup radius
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	match state:
		State.FLOATING:
			_do_float(delta)
		State.FOLLOWING:
			_do_follow(delta)
		State.UNLOCKING:
			_do_unlock(delta)

# ── Idle bob ──────────────────────────────────────────────────────────────────
func _do_float(_delta: float) -> void:
	global_position.y = origin.y + sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_amplitude
	rotation = sin(Time.get_ticks_msec() / 1000.0 * float_speed * 0.5) * 0.15   # gentle tilt

# ── Trail the player ──────────────────────────────────────────────────────────
func _do_follow(delta: float) -> void:
	if not is_instance_valid(player):
		state = State.FLOATING
		return

	var target := player.global_position + Vector2(-player.scale.x * follow_distance, 0)
	target.y += sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_amplitude

	global_position = global_position.lerp(target, follow_speed * delta)
	rotation = sin(Time.get_ticks_msec() / 1000.0 * float_speed * 0.5) * 0.15

# ── Fly to the door ───────────────────────────────────────────────────────────
func _do_unlock(delta: float) -> void:
	if not is_instance_valid(door):
		return

	var to_door := door.global_position - global_position
	if to_door.length() < 4.0:
		global_position = door.global_position
		door.unlock()           # tell the door it's been unlocked
		queue_free()            # key disappears after use
		return

	global_position += to_door.normalized() * unlock_speed * delta
	rotation += delta * 10.0   # spin dramatically as it flies

# ── Signals ───────────────────────────────────────────────────────────────────
func _on_body_entered(body: Node) -> void:
	if state == State.FLOATING and body.is_in_group("player"):
		player = body
		state  = State.FOLLOWING

## Called by the Door when the player (carrying the key) enters the door zone.
func start_unlock(target_door: Node2D) -> void:
	door  = target_door
	state = State.UNLOCKING
