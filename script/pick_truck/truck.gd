extends TextureButton



func _on_pressed() -> void:
	disabled = true
	await Global.play_and_wait(Global.SpeakType.PICK_CORRECT_TRUCK, 0.4)
	get_tree().change_scene_to_file("res://scene/stone_remove.tscn")
