extends AnimatedSprite2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start_node: String = "start"

var menu_scene = preload("res://scenes/menu.tscn")
var main_scene = preload("res://scenes/stanza.tscn")

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start_node, [self])

func back_to_menu():
	SceneTransition.change_scene("res://scenes/menu.tscn")

func start_game():
	SceneTransition.change_scene("res://scenes/stanza.tscn")
