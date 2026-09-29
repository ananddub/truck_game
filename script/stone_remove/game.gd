extends Node

var press_count := 0
@onready var truck: TextureRect = $"../background/truck"
@onready var scene_root = $"../.."

func _on_pressed() -> void:
	press_count += 1
	Progress.note_stone_press()
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
		
		# Confetti celebration!
		Confetti.burst()
		
		# Show NEXT button — do not auto-advance!
		var canvas = get_tree().current_scene.get_node_or_null("CanvasLayer")
		if canvas != null:
			var next_btn = preload("res://scene/next_button.tscn").instantiate()
			canvas.add_child(next_btn)
			next_btn.next_clicked.connect(func():
				get_tree().change_scene_to_file("res://scene/count_tyre.tscn")
			)
		else:
			get_tree().change_scene_to_file("res://scene/count_tyre.tscn")
