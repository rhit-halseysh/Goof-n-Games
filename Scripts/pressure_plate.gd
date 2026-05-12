extends Area2D

var pressed: bool = false

signal pressed_sig
signal released_sig

@export var unpressed_coords: Vector2i = Vector2i(15, 0)
@export var pressed_coords: Vector2i = Vector2i(14, 0)
@export var plate_position: Vector2i = Vector2i(0, 0)
@export var tile_layer: TileMapLayer  # drag your TileMapLayer into this in the inspector
@export var dungeon_tiles: TileSet


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("PressurePlate")
	#plate_position = tile_layer.local_to_map(global_position)
	#tile_layer.set_cell(plate_position, 0, unpressed_coords)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if pressed == false and body.is_in_group("warrior"):
		pressed = true
		pressed_sig.emit()
		#tile_layer.set_cell(plate_position, 0, pressed_coords)
		var texture = load("res://Sprites/Pressure_Down.png")
		$Sprite2D.texture = texture
		print("Pressed")

func _on_body_exited(body: Node2D) -> void:
	pressed = false
	released_sig.emit()
	#tile_layer.set_cell(plate_position, 0, unpressed_coords)
	var texture = load("res://Sprites/Pressure_Up.png")
	$Sprite2D.texture = texture
	print("Unpressed")
