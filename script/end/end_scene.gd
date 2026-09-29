extends Node2D

@onready var raju_bheem: TextureRect = $CanvasLayer/Background/raju_bheem
@onready var jagu: TextureRect = $CanvasLayer/Background/jagu
@onready var truck: TextureRect = $CanvasLayer/Background/truck
@onready var fire_left: TextureRect = $CanvasLayer/Background/fire_left
@onready var fire_mid: TextureRect = $CanvasLayer/Background/fire_mid
@onready var fire_right: TextureRect = $CanvasLayer/Background/fire_right

func _ready() -> void:
	# Reaching the end scene means the full run was completed — report it once
	# to the host app (no-op outside Android) before the celebration starts.
	Progress.submit_result()
	Confetti.burst()
	animate_celebration_characters()
	animate_fireworks_celebration()

func animate_celebration_characters() -> void:
	# Raju and Bheem joyful victory jumping loop
	if raju_bheem != null:
		raju_bheem.pivot_offset = Vector2(raju_bheem.size.x / 2.0, raju_bheem.size.y)
		var base_y = raju_bheem.position.y
		var t_bheem := create_tween().set_loops()
		t_bheem.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		t_bheem.tween_property(raju_bheem, "position:y", base_y - 24.0, 0.35)
		t_bheem.parallel().tween_property(raju_bheem, "scale", Vector2(0.96, 1.06), 0.35)
		t_bheem.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		t_bheem.tween_property(raju_bheem, "position:y", base_y, 0.35)
		t_bheem.parallel().tween_property(raju_bheem, "scale", Vector2(1.04, 0.96), 0.35)

	# Jaggu monkey playful victory dance
	if jagu != null:
		jagu.pivot_offset = Vector2(jagu.size.x / 2.0, jagu.size.y)
		var base_y = jagu.position.y
		var t_jagu := create_tween().set_loops()
		t_jagu.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		t_jagu.tween_property(jagu, "position:y", base_y - 28.0, 0.3)
		t_jagu.parallel().tween_property(jagu, "rotation_degrees", 6.0, 0.3)
		t_jagu.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		t_jagu.tween_property(jagu, "position:y", base_y, 0.3)
		t_jagu.parallel().tween_property(jagu, "rotation_degrees", -6.0, 0.3)

	# Truck joyful bounce
	if truck != null:
		truck.pivot_offset = truck.size / 2.0
		var base_y = truck.position.y
		var t_truck := create_tween().set_loops()
		t_truck.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		t_truck.tween_property(truck, "position:y", base_y - 6.0, 0.5)
		t_truck.parallel().tween_property(truck, "scale", Vector2(1.01, 1.01), 0.5)
		t_truck.tween_property(truck, "position:y", base_y, 0.5)
		t_truck.parallel().tween_property(truck, "scale", Vector2.ONE, 0.5)

func animate_fireworks_celebration() -> void:
	var fireworks = [fire_left, fire_mid, fire_right]
	for i in range(fireworks.size()):
		var fw = fireworks[i]
		if fw != null:
			fw.pivot_offset = fw.size / 2.0
			var dur = 0.5 + i * 0.18
			var t_fw := create_tween().set_loops()
			t_fw.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			t_fw.tween_property(fw, "scale", Vector2(1.18, 1.18), dur)
			t_fw.parallel().tween_property(fw, "modulate:a", 1.0, dur)
			t_fw.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			t_fw.tween_property(fw, "scale", Vector2(0.88, 0.88), dur)
			t_fw.parallel().tween_property(fw, "modulate:a", 0.6, dur)
