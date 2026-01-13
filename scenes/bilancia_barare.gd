extends Node2D

@export var final_dialogue_resource: DialogueResource
@export var final_dialogue_start: String = "start"
@export var hover_cursor: Texture2D

@onready var area_2d = $Area2D
@onready var collision_shape = $Area2D/CollisionShape2D
@onready var default_cursor = preload("res://asset_2d/Arrow2.png")

func _ready():
	visible = false
	collision_shape.disabled = true
	
	GameEvents.all_items_collected.connect(_on_all_items_collected)
	
	area_2d.input_event.connect(_on_input_event)
	area_2d.mouse_entered.connect(_on_mouse_entered)
	area_2d.mouse_exited.connect(_on_mouse_exited)

func _on_all_items_collected():
	visible = true
	
	collision_shape.set_deferred("disabled", false)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			get_viewport().set_input_as_handled()
			start_final_dialogue()

func start_final_dialogue():
	DialogueManager.show_dialogue_balloon(final_dialogue_resource, final_dialogue_start, [self])

func _on_mouse_entered():
	if not visible: return
	
	if hover_cursor:
		Input.set_custom_mouse_cursor(hover_cursor, Input.CURSOR_ARROW)
	else:
		DisplayServer.cursor_set_shape(DisplayServer.CURSOR_POINTING_HAND)

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(default_cursor)
