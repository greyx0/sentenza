extends Node2D

@onready var anim_player: AnimationPlayer = $solopiatti/AnimationPlayer
@onready var audio_player = $AudioStreamPlayer2D

#var sound = preload("res://path/to/sound.wav")

func _ready():
	GameEvents.interaction_triggered.connect(_on_interaction_received)

func _on_interaction_received(choice_id: int):
	match choice_id:
		1:
			anim_player.play("tilt_destra")
			anim_player.play_backwards("tilt_destra")
			#audio_player.stream = sound
			#audio_player.play()
		2:
			anim_player.play("tilt_sinistra")
			anim_player.play_backwards("tilt_sinistra")
			#audio_player.stream = sound
			#audio_player.play()
