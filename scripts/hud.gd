extends Control

@onready var cam_attributes: CameraAttributesPractical = $"../View/Camera".attributes
@onready var title: Control = $Title
@onready var play_button: Button = $Title/Play
@onready var credits_button: Button = $Title/Credits
@onready var credits_screen: Control = $Credits
@onready var back_button: Button = $Credits/Back
@onready var player: CharacterBody3D = $"../Player"

var title_home_x: float
var credits_home_x: float
var credits_visible_x: float

const BLUR_AMOUNT := 1.0
const TWEEN_DURATION := 0.8

var screen_width: float

func _ready() -> void:
	screen_width = get_viewport_rect().size.x
	cam_attributes.dof_blur_far_enabled = true
	cam_attributes.dof_blur_far_distance = 3.0
	cam_attributes.dof_blur_amount = BLUR_AMOUNT

	title_home_x = title.position.x
	credits_home_x = credits_screen.position.x
	credits_visible_x = title_home_x

	play_button.pressed.connect(_on_play_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	back_button.pressed.connect(_on_back_pressed)
	
	player.process_mode = Node.PROCESS_MODE_DISABLED

func _on_coin_collected(coins):
	$Coins.text = str(coins)

func _on_play_pressed() -> void:
	play_button.disabled = true
	credits_button.disabled = true
	var tween := create_tween().set_parallel(true)
	tween.tween_property(cam_attributes, "dof_blur_amount", 0.0, TWEEN_DURATION)
	tween.tween_property(title, "position:y", title.position.y - 800, TWEEN_DURATION)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.chain().tween_callback(_start_game)

func _on_credits_pressed() -> void:
	play_button.disabled = true
	credits_button.disabled = true
	
	var tween := create_tween().set_parallel(true)
	tween.tween_property(title, "position:x", -screen_width, TWEEN_DURATION)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(credits_screen, "position:x", credits_visible_x + 50, TWEEN_DURATION)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _on_back_pressed() -> void:
	var tween := create_tween().set_parallel(true)
	tween.tween_property(title, "position:x", title_home_x, TWEEN_DURATION)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(credits_screen, "position:x", credits_home_x, TWEEN_DURATION)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.chain().tween_callback(func():
		play_button.disabled = false
		credits_button.disabled = false
	)

func _start_game() -> void:
	title.hide()
	player.process_mode = Node.PROCESS_MODE_INHERIT
	
	Music.play("res://sounds/AhOhAhOh.ogg", false)
