extends Control

@onready var cam_attributes: CameraAttributesPractical = $"../View/Camera".attributes
@onready var title: Control = $Title
@onready var play_button: Button = $Title/Play
@onready var credits_button: Button = $Title/Credits

const BLUR_AMOUNT := 0.3
const TWEEN_DURATION := 1.2

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # so the menu still works while paused
	cam_attributes.dof_blur_far_enabled = true
	cam_attributes.dof_blur_far_distance = 3.0
	cam_attributes.dof_blur_amount = BLUR_AMOUNT
	play_button.pressed.connect(_on_play_pressed)
	get_tree().paused = true

func _on_coin_collected(coins):
	$Coins.text = str(coins)

func _on_play_pressed() -> void:
	play_button.disabled = true
	credits_button.disabled = true
	var tween := create_tween().set_parallel(true)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(cam_attributes, "dof_blur_amount", 0.0, TWEEN_DURATION)
	tween.tween_property(title, "position:y", title.position.y - 800, TWEEN_DURATION)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.chain().tween_callback(_start_game)

func _start_game() -> void:
	title.hide()
	get_tree().paused = false
