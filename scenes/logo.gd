extends TextureRect

@export var rotation_amount := 1.0
@export var scale_amount := 0.02
@export var speed := 2.0

var t := 0.0

func _ready() -> void:
	pivot_offset = size / 2

func _process(delta: float) -> void:
	t += delta * speed
	rotation_degrees = sin(t) * rotation_amount
	scale = Vector2.ONE * (1.0 + sin(t) * scale_amount)
