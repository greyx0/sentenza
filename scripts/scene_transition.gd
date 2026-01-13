extends CanvasLayer

@onready var animation_player = $ColorRect/AnimationPlayer

func change_scene(target_path: String) -> void:
	animation_player.play("fade")
	await animation_player.animation_finished
	
	get_tree().change_scene_to_file(target_path)
	
	animation_player.play_backwards("fade")
