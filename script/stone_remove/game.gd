extends Node

var press_count := 0
@onready var truck: TextureRect = $"../background/truck"

func _on_pressed() -> void:
	press_count += 1
	if press_count == 3:
		await Global.wait_for_speech()
		await get_tree().create_timer(0.3).timeout
		if truck != null and truck.has_method("drive_away"):
			await truck.drive_away()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scene/count_tyre.tscn")
