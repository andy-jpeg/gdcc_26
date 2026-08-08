extends Node

@export var default_volume_db := -15.0
@export var fade_duration := 1.5

var player_a: AudioStreamPlayer
var player_b: AudioStreamPlayer
var active_player: AudioStreamPlayer

var current_track: String = ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player_a = AudioStreamPlayer.new()
	player_b = AudioStreamPlayer.new()
	add_child(player_a)
	add_child(player_b)
	player_a.bus = "Music"
	player_b.bus = "Music"
	player_a.process_mode = Node.PROCESS_MODE_ALWAYS
	player_b.process_mode = Node.PROCESS_MODE_ALWAYS
	active_player = player_a

func play(path: String, fade: bool = true) -> void:
	if current_track == path:
		return
	
	var is_first_play = current_track == ""
	current_track = path
	
	var next_player = player_b if active_player == player_a else player_a
	var stream = load(path)
	
	next_player.stream = stream
	
	if fade and not is_first_play:
		next_player.volume_db = -80.0
		next_player.play(0.0)
		var tween := create_tween().set_parallel(true)
		tween.tween_property(active_player, "volume_db", -80.0, fade_duration)
		tween.tween_property(next_player, "volume_db", default_volume_db, fade_duration)
		tween.chain().tween_callback(func(): active_player.stop())
	else:
		next_player.volume_db = default_volume_db
		next_player.play(0.0)
		active_player.stop()
	
	active_player = next_player

func stop(fade: bool = true) -> void:
	current_track = ""
	if fade:
		var tween := create_tween()
		tween.tween_property(active_player, "volume_db", -80.0, fade_duration)
		tween.tween_callback(active_player.stop)
	else:
		active_player.stop()

func set_volume(linear_value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(linear_value))
