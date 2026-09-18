extends Node2D

@onready var raju_bheem: TextureRect = $CanvasLayer/Background/raju_bheem
@onready var jagu: TextureRect = $CanvasLayer/Background/jagu
@onready var truck: TextureRect = $CanvasLayer/Background/truck
@onready var fire_left: TextureRect = $CanvasLayer/Background/fire_left
@onready var fire_mid: TextureRect = $CanvasLayer/Background/fire_mid
@onready var fire_right: TextureRect = $CanvasLayer/Background/fire_right

func _ready() -> void:
	animate_characters()
	animate_fireworks()

func animate_characters() -> void:
	# Raju and Bheem gentle breathing bob
	if raju_bheem != null:
		raju_bheem.pivot_offset = raju_bheem.size / 2.0
		var orig_y = raju_bheem.position.y
		var t_bheem := create_tween().set_loops()
		t_bheem.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		t_bheem.tween_property(raju_bheem, "position:y", orig_y - 8.0, 1.3)
		t_bheem.tween_property(raju_bheem, "position:y", orig_y, 1.3)

	# Jaggu playful monkey bob and tilt
	if jagu != null:
		jagu.pivot_offset = jagu.size / 2.0
		var orig_y = jagu.position.y
		var t_jagu := create_tween().set_loops()
		t_jagu.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		t_jagu.tween_property(jagu, "position:y", orig_y - 12.0, 0.9)
		t_jagu.parallel().tween_property(jagu, "rotation_degrees", 3.0, 0.9)
		t_jagu.tween_property(jagu, "position:y", orig_y, 0.9)
		t_jagu.parallel().tween_property(jagu, "rotation_degrees", -3.0, 0.9)

	# Truck subtle engine rumble
	if truck != null:
		var orig_y = truck.position.y
		var t_truck := create_tween().set_loops()
		t_truck.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		t_truck.tween_property(truck, "position:y", orig_y - 3.0, 0.4)
		t_truck.tween_property(truck, "position:y", orig_y, 0.4)

func animate_fireworks() -> void:
	var fireworks = [fire_left, fire_mid, fire_right]
	for i in range(fireworks.size()):
		var fw = fireworks[i]
		if fw != null:
			fw.pivot_offset = fw.size / 2.0
			var dur = 0.6 + i * 0.2
			var t_fw := create_tween().set_loops()
			t_fw.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			t_fw.tween_property(fw, "scale", Vector2(1.12, 1.12), dur)
			t_fw.parallel().tween_property(fw, "modulate:a", 0.7, dur)
			t_fw.tween_property(fw, "scale", Vector2(0.92, 0.92), dur)
			t_fw.parallel().tween_property(fw, "modulate:a", 1.0, dur)
