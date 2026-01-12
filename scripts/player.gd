extends CharacterBody2D

@export var speed = 400
@onready var animated_sprite = $AnimatedSprite2D
@onready var audio_player = $AudioStreamPlayer2D 

var target = position
var auto_mode = false
var is_interacting = false

func _unhandled_input(event):
	if is_interacting:
		return
	
	if event.is_action_pressed("click"):
		target = get_global_mouse_position()
	
	if event.is_action_pressed("toggle_auto"):
		auto_mode = !auto_mode
		
		if auto_mode:
			play_music()
			if position.distance_to(target) < 10:
				pick_random_target()
		else:
			stop_music()
			target = position    

func set_interacting(value: bool):
	is_interacting = value
	if is_interacting:
		velocity = Vector2.ZERO
		target = position
		auto_mode = false
		animated_sprite.play("idle")
		stop_music()

func _physics_process(delta):
	if is_interacting:
		velocity = Vector2.ZERO
		return

	if auto_mode and position.distance_to(target) < 10:
		pick_random_target()

	if position.distance_to(target) > 5:
		velocity = position.direction_to(target) * speed
		move_and_slide()
		update_animation()
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("idle")

func pick_random_target():
	var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	target = position + (random_direction * randf_range(100, 400))

func play_music():
	if audio_player.stream and not audio_player.playing:
		audio_player.play()

func stop_music():
	audio_player.stop()

func update_animation():
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x > 0: animated_sprite.play("walk_right")
		else: animated_sprite.play("walk_left")
	else:
		if velocity.y > 0: animated_sprite.play("walk_down")
		else: animated_sprite.play("walk_up")
