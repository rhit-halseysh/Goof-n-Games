extends CanvasLayer

@export var display_time: float = 6.0  # How long instructions stay solid
@export var fade_duration: float = 2.0 # How long the fade-out takes

func _ready() -> void:
	# Ensure the UI starts fully visible
	self.modulate.a = 1.0
	
	# Start the sequence: Wait, then Fade
	start_tutorial_sequence()

func start_tutorial_sequence() -> void:
	# 1. Create a timer that doesn't pause the game
	await get_tree().create_timer(display_time).timeout
	
	# 2. Use a Tween to animate the 'alpha' (transparency) to 0
	var tween = create_tween()
	
	# We animate the "modulate:a" property (a = alpha/transparency)
	tween.tween_property(self, "modulate:a", 0.0, fade_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	
	# 3. Remove the UI from the game once it's invisible to save resources
	tween.finished.connect(queue_free)
