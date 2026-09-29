extends TextureButton

var normal_scale := Vector2.ONE
var pressed_scale := Vector2(0.9, 0.9)
var idle_tween: Tween

func _ready() -> void:
	pivot_offset = size / 2.0
	scale = Vector2.ZERO
	rotation_degrees = 2.0
	Global.play(Global.SpeakType.END_CELEBRATION)
	
	# Entrance animation: animated ho kar aaye
	await get_tree().create_timer(0.2).timeout
	var enter_tween := create_tween()
	enter_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	enter_tween.tween_property(self, "scale", normal_scale, 0.6)
	enter_tween.parallel().tween_property(self, "rotation_degrees", 0.0, 0.6)
	await enter_tween.finished
	
	start_idle_animation()

func start_idle_animation() -> void:
	idle_tween = create_tween().set_loops()
	idle_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	idle_tween.tween_property(self, "scale", Vector2(1.08, 1.08), 0.75)
	idle_tween.parallel().tween_property(self, "rotation_degrees", 2.0, 0.75)
	idle_tween.tween_property(self, "scale", Vector2(0.96, 0.96), 0.75)
	idle_tween.parallel().tween_property(self, "rotation_degrees", -2.0, 0.75)

func _on_pressed() -> void:
	disabled = true
	if idle_tween != null:
		idle_tween.kill()
	#await Global.play_and_wait(Global.SpeakType.END_REPLAY_CLICK, 0.4)
	Progress.start_run() # fresh run — counters reset; submit re-arms
	get_tree().change_scene_to_file("res://scene/pick_truck.tscn")

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
	if not disabled and idle_tween != null:
		idle_tween.play()
