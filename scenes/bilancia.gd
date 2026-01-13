extends CanvasLayer

@onready var anim_player: AnimationPlayer = $CenterContainer/TextureRect/solopiatti/AnimationPlayer
@onready var audio_player = $AudioStreamPlayer2D

var sound = preload("res://audio/tilt_bilancia.mp3")

func _ready():
	GameEvents.interaction_triggered.connect(_on_interaction_received)
	visible = false

func _on_interaction_received(choice_id: int):
	match choice_id:
		1:
			visible = true
			await get_tree().create_timer(1.0).timeout
			anim_player.play("tilt_destra")
			audio_player.stream = sound
			audio_player.play()
			await anim_player.animation_finished
			anim_player.play_backwards("tilt_destra")
			await anim_player.animation_finished
			visible = false
		2:
			visible = true
			await get_tree().create_timer(1.0).timeout
			anim_player.play("tilt_sinistra")
			audio_player.stream = sound
			audio_player.play()
			await anim_player.animation_finished
			anim_player.play_backwards("tilt_sinistra")
			await anim_player.animation_finished
			visible = false
