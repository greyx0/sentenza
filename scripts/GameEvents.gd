extends Node

signal interaction_triggered(choice_id: int)

signal all_items_collected

var total_items_needed: int = 8 
var collected_items: Array[String] = []

func register_item_collection(item_id: String):
	if item_id not in collected_items:
		collected_items.append(item_id)
		print("Collected: ", item_id, " | Total: ", collected_items.size())
		
		if collected_items.size() >= total_items_needed:
			all_items_collected.emit()

func _input(event):
	if event.is_action_pressed("ui_cancel"): # Usually the Esc key
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.set_interacting(false)
			print("Forced interaction to STOP")
			
func last_cutscene():
	SceneTransition.change_scene("res://scenes/cutscene_finale.tscn")
