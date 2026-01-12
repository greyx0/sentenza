extends StaticBody2D

@export var hover_cursor: Texture2D
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

@onready var sprite_1 = $bed
@onready var sprite_2 = $bed_1
@onready var sprite_3 = $bed_2
@onready var collision_shape_2d: CollisionShape2D = $Area2D/dress_collision
@onready var default_cursor = preload("res://asset_2d/Arrow2.png")

func _ready():
	$Area2D.mouse_entered.connect(_on_mouse_entered)
	$Area2D.mouse_exited.connect(_on_mouse_exited)
	$Area2D.input_event.connect(_on_area_2d_input_event)

func _on_mouse_entered():
	if hover_cursor:
		Input.set_custom_mouse_cursor(hover_cursor, Input.CURSOR_ARROW)
	else:
		DisplayServer.cursor_set_shape(DisplayServer.CURSOR_POINTING_HAND)

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(default_cursor)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		start_interaction()

func start_interaction():
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start, [self])

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
