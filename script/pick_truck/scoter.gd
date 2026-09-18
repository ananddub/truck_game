extends TextureButton


var normal_scale := Vector2.ONE
var pressed_scale := Vector2(0.95, 0.95)



func _on_button_down() -> void:
	Global.play(Global.SpeakType.PICK_WRONG_SCOOTER)
	for child in get_children():
		if child is Control:
			var tween := create_tween()
			tween.set_trans(Tween.TRANS_BACK)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(child, "scale", pressed_scale, 0.09)


func _on_button_up() -> void:
	for child in get_children():
		if child is Control:
			var tween := create_tween()
			tween.set_trans(Tween.TRANS_BACK)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(child, "scale", normal_scale, 0.1)

	
