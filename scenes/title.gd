extends TextureRect

@export var rotation_amount := 10.0
@export var scale_amount := 0.05
@export var cycle_duration := 1.5

func _ready() -> void:
	pivot_offset = size / 2
	_start_wobble()

func _start_wobble() -> void:
	var tween := create_tween().set_loops()
	
	tween.tween_property(self, "rotation_degrees", rotation_amount, cycle_duration / 2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self, "scale", Vector2.ONE * (1.0 + scale_amount), cycle_duration / 2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self, "rotation_degrees", -rotation_amount, cycle_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self, "scale", Vector2.ONE * (1.0 - scale_amount), cycle_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self, "rotation_degrees", 0.0, cycle_duration / 2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self, "scale", Vector2.ONE, cycle_duration / 2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
