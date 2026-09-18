extends Node2D

@onready var kaliya: TextureRect = $CanvasLayer/background/kaliya
@onready var card: TextureRect = $CanvasLayer/background/card
@onready var board: TextureRect = $CanvasLayer/background/board

var kaliya_idle_tween: Tween
var kaliya_base_pos: Vector2

func _ready() -> void:
	animate_card_entrance()
	animate_kaliya_idle()
	animate_board_creak()

func animate_card_entrance() -> void:
	if card != null:
		var target_y = card.position.y
		card.position.y = target_y + 320.0
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(card, "position:y", target_y, 0.8)

func animate_kaliya_idle() -> void:
	if kaliya == null:
		return
	kaliya.pivot_offset = Vector2(kaliya.size.x / 2.0, kaliya.size.y)
	kaliya_base_pos = kaliya.position
	kaliya_idle_tween = create_tween().set_loops()
	kaliya_idle_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	kaliya_idle_tween.tween_property(kaliya, "scale:y", 1.04, 1.1)
	kaliya_idle_tween.parallel().tween_property(kaliya, "rotation_degrees", 1.5, 1.1)
	kaliya_idle_tween.tween_property(kaliya, "scale:y", 1.0, 1.1)
	kaliya_idle_tween.parallel().tween_property(kaliya, "rotation_degrees", -1.5, 1.1)

func kaliya_cheer() -> void:
	if kaliya == null:
		return
	if kaliya_idle_tween != null:
		kaliya_idle_tween.pause()
	
	var cheer_tween := create_tween()
	cheer_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	cheer_tween.tween_property(kaliya, "position:y", kaliya_base_pos.y - 30.0, 0.25)
	cheer_tween.parallel().tween_property(kaliya, "scale", Vector2(1.08, 1.08), 0.25)
	cheer_tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	cheer_tween.tween_property(kaliya, "position:y", kaliya_base_pos.y, 0.35)
	cheer_tween.parallel().tween_property(kaliya, "scale", Vector2.ONE, 0.35)
	await cheer_tween.finished
	
	if kaliya_idle_tween != null:
		kaliya_idle_tween.play()

func kaliya_victory() -> void:
	if kaliya == null:
		return
	if kaliya_idle_tween != null:
		kaliya_idle_tween.kill()
	
	var vic_tween := create_tween().set_loops(3)
	vic_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	vic_tween.tween_property(kaliya, "position:y", kaliya_base_pos.y - 45.0, 0.25)
	vic_tween.parallel().tween_property(kaliya, "rotation_degrees", 4.0, 0.25)
	vic_tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	vic_tween.tween_property(kaliya, "position:y", kaliya_base_pos.y, 0.25)
	vic_tween.parallel().tween_property(kaliya, "rotation_degrees", -4.0, 0.25)

func card_bump() -> void:
	if card == null:
		return
	card.pivot_offset = card.size / 2.0
	var bump_tween := create_tween()
	bump_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	bump_tween.tween_property(card, "scale", Vector2(1.03, 1.03), 0.12)
	bump_tween.tween_property(card, "scale", Vector2.ONE, 0.18)

func animate_board_creak() -> void:
	if board != null:
		board.pivot_offset = Vector2(board.size.x / 2.0, 0)
		var b_tween := create_tween().set_loops()
		b_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		b_tween.tween_property(board, "rotation_degrees", 2.0, 2.0)
		b_tween.tween_property(board, "rotation_degrees", -2.0, 2.0)
