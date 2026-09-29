extends TextureButton
## Toddler-friendly compact animated NEXT button with breathing pulse and spring entrance.

signal next_clicked

func _ready() -> void:
	texture_normal = preload("res://assets/common/next.png")
	ignore_texture_size = true
	stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	custom_minimum_size = Vector2(200, 125)
	size = Vector2(200, 125)
	update_position()
	if get_viewport() != null:
		get_viewport().size_changed.connect(update_position)
	pivot_offset = size / 2.0
	scale = Vector2.ZERO

	# Animate bounce entrance
	var t_in := create_tween()
	t_in.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t_in.tween_property(self, "scale", Vector2.ONE, 0.45)
	await t_in.finished

	# Subtle breathing pulse
	var t_pulse := create_tween().set_loops()
	t_pulse.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	t_pulse.tween_property(self, "scale", Vector2(1.06, 1.06), 0.7)
	t_pulse.tween_property(self, "scale", Vector2(1.0, 1.0), 0.7)

	pressed.connect(_on_self_pressed)

func _on_self_pressed() -> void:
	disabled = true
	var t_click := create_tween()
	t_click.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t_click.tween_property(self, "scale", Vector2(0.92, 0.92), 0.12)
	t_click.tween_property(self, "scale", Vector2(1.05, 1.05), 0.12)
	await t_click.finished
	next_clicked.emit()

func update_position() -> void:
	var vp_size = get_viewport_rect().size
	if vp_size.x > 0 and vp_size.y > 0:
		position = Vector2(vp_size.x - size.x - 60.0, vp_size.y - size.y - 45.0)
