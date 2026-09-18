extends TextureRect

var idle_tween: Tween

func _ready() -> void:
	# Center pivot for clean scaling and rotation
	pivot_offset = size / 2.0
	scale = Vector2.ZERO
	rotation_degrees = -3.0
	
	# Entrance animation: animated ho kar aaye
	var enter_tween := create_tween()
	enter_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	enter_tween.tween_property(self, "scale", Vector2.ONE, 0.7)
	enter_tween.parallel().tween_property(self, "rotation_degrees", 0.0, 0.7)
	await enter_tween.finished
	
	# Idle animation: thoda hile (breathing + gentle tilt)
	start_idle_animation()

func start_idle_animation() -> void:
	idle_tween = create_tween().set_loops()
	idle_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	idle_tween.tween_property(self, "scale", Vector2(1.04, 1.04), 1.2)
	idle_tween.parallel().tween_property(self, "rotation_degrees", 1.8, 1.2)
	idle_tween.tween_property(self, "scale", Vector2(0.97, 0.97), 1.2)
	idle_tween.parallel().tween_property(self, "rotation_degrees", -1.8, 1.2)
