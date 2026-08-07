extends Node3D

@export_group("Properties")
@export var target: Node

@export_group("Rotation")
@export var rotation_speed = 120

var camera_rotation: Vector3
var zoom = 0
var camera_offset: Vector3 = Vector3.ZERO

@onready var camera = $Camera

func _ready():
	camera_offset = camera.position
	camera_rotation = rotation_degrees

func _physics_process(delta):
	if target:
		self.position = self.position.lerp(target.position, delta * 4)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * 6)
	
	var desired_camera_position = camera.position
	desired_camera_position.x = camera_offset.x
	desired_camera_position.y = camera_offset.y
	desired_camera_position.z = camera_offset.z
	
	camera.position = camera.position.lerp(desired_camera_position, 2 * delta)
	
	handle_input(delta)

func handle_input(delta):
	var input := Vector3.ZERO
	
	input.y = Input.get_axis("camera_left", "camera_right")
	input.x = Input.get_axis("camera_up", "camera_down")
	
	camera_rotation += input.limit_length(1.0) * rotation_speed * delta
	camera_rotation.x = clamp(camera_rotation.x, -80, -10)
