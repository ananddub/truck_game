extends TextureButton

var normal_scale := Vector2.ONE
var pressed_scale := Vector2(0.95, 0.95)

func _ready() -> void:
	pivot_offset = size / 2.0

func _on_button_down() -> void:
	Global.play(Global.SpeakType.PICK_WRONG_SCOOTER)
	Progress.note_wrong_pick()
	shake_wrong()
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

func shake_wrong() -> void:
	var orig_x = position.x
	var t := create_tween()
	t.set_trans(Tween.TRANS_SINE)
	t.tween_property(self, "position:x", orig_x - 12.0, 0.05)
	t.tween_property(self, "position:x", orig_x + 12.0, 0.05)
	t.tween_property(self, "position:x", orig_x - 8.0, 0.05)
	t.tween_property(self, "position:x", orig_x + 8.0, 0.05)
	t.tween_property(self, "position:x", orig_x, 0.05)
	
	var t_col := create_tween()
	t_col.tween_property(self, "modulate", Color(1.0, 0.6, 0.6), 0.1)
	t_col.tween_property(self, "modulate", Color.WHITE, 0.3)
