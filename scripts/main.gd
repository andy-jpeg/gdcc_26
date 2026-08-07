extends Node3D

func _ready() -> void:
	if RenderingServer.get_current_rendering_method() == "gl_compatibility":
		$Sun.light_energy = 0.24
		$Sun.shadow_opacity = 0.85
		$Environment.environment.background_energy_multiplier = 0.25
