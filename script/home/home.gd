extends TextureButton

var normal_scale := Vector2.ONE
var pressed_scale := Vector2(0.9, 0.9)
var idle_tween: Tween

func _ready() -> void:
	pivot_offset = size / 2.0
	scale = Vector2.ZERO
	
	# Entrance animation: animated ho kar aaye
	await get_tree().create_timer(0.3).timeout
	var enter_tween := create_tween()
	enter_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	enter_tween.tween_property(self, "scale", normal_scale, 0.6)
	await enter_tween.finished
	
	start_idle_animation()

func start_idle_animation() -> void:
	idle_tween = create_tween().set_loops()
	idle_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	idle_tween.tween_property(self, "scale", Vector2(1.05, 1.05), 1.0)
	idle_tween.parallel().tween_property(self, "rotation_degrees", -2.0, 1.0)
	idle_tween.tween_property(self, "scale", Vector2(0.96, 0.96), 1.0)
	idle_tween.parallel().tween_property(self, "rotation_degrees", 2.0, 1.0)

func _on_pressed() -> void:
	print("home btn pressed")

func _on_button_down() -> void:
	if idle_tween != null:
		idle_tween.pause()
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", pressed_scale, 0.09)

func _on_button_up() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", normal_scale, 0.1)
	await tween.finished
	if idle_tween != null:
		idle_tween.play()
