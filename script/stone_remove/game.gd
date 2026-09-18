extends Node

var press_count := 0
@onready var truck: TextureRect = $"../background/truck"
@onready var scene_root = $"../.."

func _on_pressed() -> void:
	press_count += 1
	if scene_root != null:
		if scene_root.has_method("card_bump"):
			scene_root.card_bump()
		if scene_root.has_method("kaliya_cheer"):
			scene_root.kaliya_cheer()
	
	if press_count == 3:
		if scene_root != null and scene_root.has_method("kaliya_victory"):
			scene_root.kaliya_victory()
		await Global.wait_for_speech()
		await get_tree().create_timer(0.3).timeout
		if truck != null and truck.has_method("drive_away"):
			await truck.drive_away()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scene/count_tyre.tscn")
