extends Node2D

@onready var truck: TextureRect = $CanvasLayer/Background/truck
@onready var chota_bheem_raju: TextureRect = $CanvasLayer/Background/chota_bheem_raju
@onready var auncle: TextureRect = $CanvasLayer/Background/auncle
@onready var bottom_left: TextureRect = $CanvasLayer/Background/bottom_left
@onready var bottom_right: TextureRect = $CanvasLayer/Background/bottom_right
@onready var board: TextureRect = $CanvasLayer/Background/TextureRect

var bheem_idle_tween: Tween
var bheem_base_pos: Vector2
var auncle_idle_tween: Tween
var auncle_base_pos: Vector2

func _ready() -> void:
	animate_entrances()
	animate_characters()

func animate_entrances() -> void:
	# Board drops down from top
	if board != null:
		board.pivot_offset = board.size / 2.0
		var target_y = board.position.y
		board.position.y = target_y - 180.0
		var t_board := create_tween()
		t_board.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		t_board.tween_property(board, "position:y", target_y, 0.7)
		t_board.tween_callback(func():
			var t_float := create_tween().set_loops()
			t_float.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			t_float.tween_property(board, "rotation_degrees", 1.5, 1.5)
			t_float.tween_property(board, "rotation_degrees", -1.5, 1.5)
		)

	# Bottom banners slide up
	if bottom_left != null:
		var target_y = bottom_left.position.y
		bottom_left.position.y = target_y + 150.0
		var t_bl := create_tween()
		t_bl.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		t_bl.tween_property(bottom_left, "position:y", target_y, 0.6)

	if bottom_right != null:
		var target_y = bottom_right.position.y
		bottom_right.position.y = target_y + 150.0
		var t_br := create_tween()
		t_br.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		t_br.tween_property(bottom_right, "position:y", target_y, 0.65)

func animate_characters() -> void:
	# Bheem & Raju idle breathing bob
	if chota_bheem_raju != null:
		chota_bheem_raju.pivot_offset = Vector2(chota_bheem_raju.size.x / 2.0, chota_bheem_raju.size.y)
		bheem_base_pos = chota_bheem_raju.position
		bheem_idle_tween = create_tween().set_loops()
		bheem_idle_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		bheem_idle_tween.tween_property(chota_bheem_raju, "position:y", bheem_base_pos.y - 10.0, 1.2)
		bheem_idle_tween.parallel().tween_property(chota_bheem_raju, "scale:y", 1.03, 1.2)
		bheem_idle_tween.tween_property(chota_bheem_raju, "position:y", bheem_base_pos.y, 1.2)
		bheem_idle_tween.parallel().tween_property(chota_bheem_raju, "scale:y", 1.0, 1.2)

	# Uncle idle bob and tool tilt
	if auncle != null:
		auncle.pivot_offset = Vector2(auncle.size.x / 2.0, auncle.size.y)
		auncle_base_pos = auncle.position
		auncle_idle_tween = create_tween().set_loops()
		auncle_idle_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		auncle_idle_tween.tween_property(auncle, "position:y", auncle_base_pos.y - 8.0, 1.1)
		auncle_idle_tween.parallel().tween_property(auncle, "rotation_degrees", 1.5, 1.1)
		auncle_idle_tween.tween_property(auncle, "position:y", auncle_base_pos.y, 1.1)
		auncle_idle_tween.parallel().tween_property(auncle, "rotation_degrees", -1.5, 1.1)

	# Truck subtle engine rumble
	if truck != null:
		var orig_y = truck.position.y
		var t_truck := create_tween().set_loops()
		t_truck.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		t_truck.tween_property(truck, "position:y", orig_y - 3.0, 0.45)
		t_truck.tween_property(truck, "position:y", orig_y, 0.45)

func on_tyre_counted(count_val: int) -> void:
	if count_val < 4:
		# Mid count cheers
		cheer_characters()
	else:
		# Final victory celebration
		celebrate_characters()

func cheer_characters() -> void:
	if chota_bheem_raju != null:
		if bheem_idle_tween != null:
			bheem_idle_tween.pause()
		var t := create_tween()
		t.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		t.tween_property(chota_bheem_raju, "position:y", bheem_base_pos.y - 25.0, 0.2)
		t.parallel().tween_property(chota_bheem_raju, "scale", Vector2(1.06, 1.06), 0.2)
		t.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		t.tween_property(chota_bheem_raju, "position:y", bheem_base_pos.y, 0.3)
		t.parallel().tween_property(chota_bheem_raju, "scale", Vector2.ONE, 0.3)
		t.tween_callback(func():
			if bheem_idle_tween != null:
				bheem_idle_tween.play()
		)

	if auncle != null:
		if auncle_idle_tween != null:
			auncle_idle_tween.pause()
		var t := create_tween()
		t.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		t.tween_property(auncle, "position:y", auncle_base_pos.y - 20.0, 0.2)
		t.parallel().tween_property(auncle, "rotation_degrees", 4.0, 0.2)
		t.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		t.tween_property(auncle, "position:y", auncle_base_pos.y, 0.3)
		t.parallel().tween_property(auncle, "rotation_degrees", 0.0, 0.3)
		t.tween_callback(func():
			if auncle_idle_tween != null:
				auncle_idle_tween.play()
		)

func celebrate_characters() -> void:
	if bheem_idle_tween != null:
		bheem_idle_tween.kill()
	if auncle_idle_tween != null:
		auncle_idle_tween.kill()

	if chota_bheem_raju != null:
		var t_bheem := create_tween().set_loops(4)
		t_bheem.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		t_bheem.tween_property(chota_bheem_raju, "position:y", bheem_base_pos.y - 35.0, 0.22)
		t_bheem.parallel().tween_property(chota_bheem_raju, "scale", Vector2(1.08, 1.08), 0.22)
		t_bheem.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		t_bheem.tween_property(chota_bheem_raju, "position:y", bheem_base_pos.y, 0.22)
		t_bheem.parallel().tween_property(chota_bheem_raju, "scale", Vector2.ONE, 0.22)

	if auncle != null:
		var t_auncle := create_tween().set_loops(4)
		t_auncle.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		t_auncle.tween_property(auncle, "position:y", auncle_base_pos.y - 30.0, 0.22)
		t_auncle.parallel().tween_property(auncle, "rotation_degrees", 5.0, 0.22)
		t_auncle.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		t_auncle.tween_property(auncle, "position:y", auncle_base_pos.y, 0.22)
		t_auncle.parallel().tween_property(auncle, "rotation_degrees", -5.0, 0.22)

	if truck != null:
		var orig_y = truck.position.y
		var t_tr := create_tween().set_loops(4)
		t_tr.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		t_tr.tween_property(truck, "position:y", orig_y - 15.0, 0.22)
		t_tr.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		t_tr.tween_property(truck, "position:y", orig_y, 0.22)
