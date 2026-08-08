extends Control

@onready var top_border: Control = $TopBorder
@onready var bottom_border: Control = $BottomBorder
@onready var dialogue: Label = $BottomBorder/Dialogue

@export var border_height := 154.0
@export var transition_duration := 0.6
@export var typewriter_speed := 0.03

var top_home_y: float
var bottom_home_y: float
var typing := false

func _ready() -> void:
	top_home_y = top_border.position.y
	bottom_home_y = bottom_border.position.y

func show_cutscene() -> void:
	print("Cutscene size: ", size, " | BottomBorder size: ", bottom_border.size, " | Viewport size: ", get_viewport_rect().size)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(top_border, "position:y", 0.0, transition_duration)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(bottom_border, "position:y", size.y - bottom_border.size.y, transition_duration)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func hide_cutscene() -> void:
	var tween := create_tween().set_parallel(true)
	tween.tween_property(top_border, "position:y", top_home_y, transition_duration)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(bottom_border, "position:y", bottom_home_y, transition_duration)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

func type_dialogue(text: String) -> void:
	if typing:
		return
	typing = true
	dialogue.text = text
	dialogue.visible_characters = 0
	
	var char_count = text.length()
	for i in range(char_count + 1):
		if not typing:
			break
		dialogue.visible_characters = i
		await get_tree().create_timer(typewriter_speed).timeout
	
	dialogue.visible_characters = char_count
	typing = false

func skip_typewriter() -> void:
	typing = false
	if dialogue.text != "":
		dialogue.visible_characters = dialogue.text.length()
