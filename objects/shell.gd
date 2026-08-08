extends Area3D

var time := 0.0
var grabbed := false
var follow_target: Node3D = null

@export var follow_offset := Vector3(0.5, 0.2, -1.0)
@export var follow_speed := 4.0

@export var bob_height := 0.1
@export var bob_speed := 3.0

func _on_body_entered(body):
	if body.has_method("collect_coin") and !grabbed:
		body.collect_coin()
		
		Audio.play("res://sounds/coin.ogg")
		
		follow_target = body
		grabbed = true
		
		set_deferred("monitoring", false)

func _process(delta):
	rotate_y(2 * delta)
	
	if grabbed and follow_target:
		var bob = sin(time * bob_speed) * bob_height
		var rotated_offset = follow_offset.rotated(Vector3.UP, follow_target.rotation.y)
		var desired_position = follow_target.global_position + rotated_offset + Vector3(0, bob, 0)
		global_position = global_position.lerp(desired_position, follow_speed * delta)
		time += delta
	else:
		position.y += (cos(time * 5) * 1) * delta
		time += delta
