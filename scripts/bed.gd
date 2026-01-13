extends StaticBody2D

@export var hover_cursor: Texture2D
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

@export_group("Game Events Settings")
@export var item_id: String = "bed"
@export var disappear_on_finish: bool = true 

@onready var sprite_1 = $bed
@onready var sprite_2 = $bed_1
@onready var sprite_3 = $bed_2
@onready var collision_shape_2d: CollisionShape2D = $Area2D/dress_collision
@onready var default_cursor = preload("res://asset_2d/Arrow2.png")

var is_interaction_finished = false

func _ready():
	$Area2D.mouse_entered.connect(_on_mouse_entered)
	$Area2D.mouse_exited.connect(_on_mouse_exited)
	$Area2D.input_event.connect(_on_area_2d_input_event)
	
	# Check if previously collected
	if GameEvents.collected_items.has(item_id):
		is_interaction_finished = true
		if disappear_on_finish:
			queue_free()
		else:
			# Optional: If it shouldn't disappear, ensure collision is off 
			# so we don't trigger it again
			collision_shape_2d.disabled = true 

func _on_mouse_entered():
	if not is_interaction_finished:
		if hover_cursor:
			Input.set_custom_mouse_cursor(hover_cursor, Input.CURSOR_ARROW)
		else:
			DisplayServer.cursor_set_shape(DisplayServer.CURSOR_POINTING_HAND)

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(default_cursor)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if is_interaction_finished: return # Stop interaction if already done
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			get_viewport().set_input_as_handled()
			start_interaction()
			
			var player = get_tree().get_first_node_in_group("player")
			if player: player.set_interacting(true)

func start_interaction():
	var active_sprite = sprite_1
	if sprite_2.visible: active_sprite = sprite_2
	if sprite_3.visible: active_sprite = sprite_3
	
	var balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start, [self])
	if balloon:
		balloon.tree_exited.connect(_on_balloon_closed)

func _on_balloon_closed():
	var player = get_tree().get_first_node_in_group("player")
	if player: player.set_interacting(false)

	finish_interaction()

func finish_interaction():
	if is_interaction_finished: return
	
	is_interaction_finished = true

	GameEvents.register_item_collection(item_id)

	collision_shape_2d.set_deferred("disabled", true)
	Input.set_custom_mouse_cursor(default_cursor)

	if disappear_on_finish == true:
		sprite_1.visible = false
		sprite_2.visible = false
		sprite_3.visible = false
		await get_tree().create_timer(0.1).timeout
		queue_free()
	else:
		print("Bed stays")


func trigger_sequence_bed_1(choice_id: int):
	sprite_1.visible = false
	sprite_2.visible = true

	collision_shape_2d.set_deferred("disabled", true)
	GameEvents.interaction_triggered.emit(choice_id)

func trigger_sequence_bed_2(choice_id: int):
	sprite_1.visible = false
	sprite_3.visible = true

	collision_shape_2d.set_deferred("disabled", true)
	GameEvents.interaction_triggered.emit(choice_id)
