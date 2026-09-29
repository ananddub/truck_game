extends TextureButton

func _ready() -> void:
	pivot_offset = size / 2.0

func _on_pressed() -> void:
	disabled = true
	
	# Correct answer celebratory bounce & golden glow
	var t := create_tween()
	t.set_parallel(true)
	t.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "scale", Vector2(1.15, 1.15), 0.4)
	t.tween_property(self, "modulate", Color(1.2, 1.2, 0.9), 0.3)
	
	Confetti.burst()
	await Global.play_and_wait(Global.SpeakType.PICK_CORRECT_TRUCK, 0.4)
	
	# Show NEXT button — do not auto-advance!
	var canvas = get_tree().current_scene.get_node_or_null("CanvasLayer")
	if canvas != null:
		var next_btn = preload("res://scene/next_button.tscn").instantiate()
		canvas.add_child(next_btn)
		next_btn.next_clicked.connect(func():
			get_tree().change_scene_to_file("res://scene/stone_remove.tscn")
		)
	else:
		get_tree().change_scene_to_file("res://scene/stone_remove.tscn")
