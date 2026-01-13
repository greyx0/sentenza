extends Node2D

@export var hover_cursor: Texture2D
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

@export_group("Game Events Settings")
@export var item_id: String = "relationship"
@export var disappear_on_finish: bool = true

@export_group("UI Settings")
@export var ui_preview_rect: TextureRect 
@export var extra_visibility_time: float = 0.9
@export var fade_duration: float = 0.5

@onready var sprite_1 = $relazione
@onready var sprite_2 = $relazione_1
@onready var sprite_3 = $relazione_2
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var default_cursor = preload("res://asset_2d/Arrow2.png")

func _ready():
	$Area2D.mouse_entered.connect(_on_mouse_entered)
	$Area2D.mouse_exited.connect(_on_mouse_exited)
	$Area2D.input_event.connect(_on_area_2d_input_event)

	if GameEvents.collected_items.has(item_id) and disappear_on_finish:
		queue_free()
		return

	if ui_preview_rect:
		ui_preview_rect.modulate.a = 0 
		ui_preview_rect.get_parent().visible = false

func _on_mouse_entered():
	if hover_cursor:
		Input.set_custom_mouse_cursor(hover_cursor, Input.CURSOR_ARROW)
	else:
		DisplayServer.cursor_set_shape(DisplayServer.CURSOR_POINTING_HAND)

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(default_cursor)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			get_viewport().set_input_as_handled()
			
			start_interaction()

			var player = get_tree().get_first_node_in_group("player")
			if player:
				player.set_interacting(true)
		


func start_interaction():
	var active_sprite = sprite_1
	if sprite_2.visible: active_sprite = sprite_2
	if sprite_3.visible: active_sprite = sprite_3
	
	show_ui_sprite(active_sprite.texture)
	
	var balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start, [self])
	if balloon:
		balloon.tree_exited.connect(_on_balloon_closed)

func show_ui_sprite(tex: Texture):
	if ui_preview_rect:
		ui_preview_rect.texture = tex
		ui_preview_rect.get_parent().visible = true
		ui_preview_rect.modulate.a = 1.0

func _on_balloon_closed():
	await get_tree().create_timer(extra_visibility_time).timeout
	
	if ui_preview_rect:
		var tween = create_tween()
		tween.tween_property(ui_preview_rect, "modulate:a", 0.0, fade_duration)
		await tween.finished
		ui_preview_rect.get_parent().visible = false
		
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_interacting(false)
	
	if disappear_on_finish:
		handle_disappearance()

func handle_disappearance():
	GameEvents.register_item_collection(item_id)
	sprite_1.visible = false
	sprite_2.visible = false
	sprite_3.visible = false
	
	collision_shape_2d.set_deferred("disabled", true)
	
	Input.set_custom_mouse_cursor(default_cursor)
	
	await get_tree().create_timer(0.1).timeout
	queue_free()


func trigger_sequence_rela_1(choice_id: int):
	sprite_1.visible = false
	sprite_2.visible = true
	
	if ui_preview_rect:
		ui_preview_rect.texture = sprite_2.texture
		
	collision_shape_2d.set_deferred("disabled", true)
	GameEvents.interaction_triggered.emit(choice_id)

func trigger_sequence_rela_2(choice_id: int):
	sprite_1.visible = false
	sprite_3.visible = true
	
	if ui_preview_rect:
		ui_preview_rect.texture = sprite_3.texture
		
	collision_shape_2d.set_deferred("disabled", true)
	GameEvents.interaction_triggered.emit(choice_id)
