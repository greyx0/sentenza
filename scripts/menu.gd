extends Node2D

@export_file("*.tscn") var game_scene_path: String

@onready var start_button: Button = $CanvasLayer/Control/Start_button

func _ready():
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	SceneTransition.change_scene(game_scene_path)
