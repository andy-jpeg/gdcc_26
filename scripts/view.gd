extends Node3D

@export_group("Properties")
@export var target: Node

@export_group("Rotation")
@export var rotation_speed = 120
@export var mouse_sensitivity = 0.15

@export_group("Zoom")
@export var zoom_speed = 0.5
@export var zoom_min = -5.0
@export var zoom_max = 5.0

@export_group("Collision")
@export var collision_margin = 0.3

var camera_rotation: Vector3
var zoom = 0.0
var camera_offset: Vector3 = Vector3.ZERO

@onready var camera = $Camera

func _ready():
	camera_offset = camera.position
	camera_rotation = rotation_degrees

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		camera_rotation.y -= event.relative.x * mouse_sensitivity
		camera_rotation.x -= event.relative.y * mouse_sensitivity
		camera_rotation.x = clamp(camera_rotation.x, -90, 90)

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom -= zoom_speed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom += zoom_speed
		zoom = clamp(zoom, zoom_min, zoom_max)

	if event is InputEventPanGesture:
		zoom += event.delta.y * zoom_speed
		zoom = clamp(zoom, zoom_min, zoom_max)

func _physics_process(delta):
	if target:
		self.position = self.position.lerp(target.position, delta * 4)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * 6)
	
	var desired_camera_position = camera.position
	desired_camera_position.x = camera_offset.x
	desired_camera_position.y = camera_offset.y
	desired_camera_position.z = camera_offset.z + zoom
	
	var safe_position = get_collision_safe_position(desired_camera_position)
	camera.position = camera.position.lerp(safe_position, 8 * delta)
	
	handle_input(delta)

func get_collision_safe_position(desired_local_pos: Vector3) -> Vector3:
	var space_state = get_world_3d().direct_space_state
	var pivot_world = global_position
	var desired_world = to_global(desired_local_pos)
	
	var query = PhysicsRayQueryParameters3D.create(pivot_world, desired_world)
	query.exclude = [target] if target else []
	query.collision_mask = 0xFFFFFFFF
	
	var result = space_state.intersect_ray(query)
	var safe_pos = desired_local_pos
	
	if result:
		var hit_distance = pivot_world.distance_to(result.position)
		var full_distance = pivot_world.distance_to(desired_world)
		var safe_ratio = clamp((hit_distance - collision_margin) / full_distance, 0.0, 1.0)
		safe_pos = desired_local_pos * safe_ratio
	
	var candidate_world = to_global(safe_pos)
	var floor_query = PhysicsRayQueryParameters3D.create(
		candidate_world + Vector3.UP * 0.2,
		candidate_world + Vector3.DOWN * 0.5
	)
	floor_query.exclude = [target] if target else []
	floor_query.collision_mask = 0xFFFFFFFF
	var floor_result = space_state.intersect_ray(floor_query)
	
	if floor_result:
		var floor_y_local = to_local(floor_result.position).y
		
		if safe_pos.y < floor_y_local + collision_margin:
			safe_pos.y = floor_y_local + collision_margin
	
	return safe_pos

func handle_input(delta):
	var input := Vector3.ZERO
	
	input.y = Input.get_axis("camera_right", "camera_left")
	input.x = Input.get_axis("camera_up", "camera_down")
	
	camera_rotation += input.limit_length(1.0) * rotation_speed * delta
	camera_rotation.x = clamp(camera_rotation.x, -90, 90)
