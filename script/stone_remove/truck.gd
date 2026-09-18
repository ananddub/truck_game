extends TextureRect

@onready var animation_board: AnimationPlayer = $"../board/AnimationPlayer"
@onready var truck_position: TextureRect = $"../../truck_position"

func _ready() -> void:
	# Get dynamic target position from truck_position
	var target_pos: Vector2
	if truck_position != null:
		target_pos = truck_position.global_position
	else:
		target_pos = global_position
	
	# Start offscreen right
	var screen_w = get_viewport_rect().size.x
	global_position = Vector2(screen_w + 200, target_pos.y)
	
	# Animate dynamically to truck_position
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", target_pos, 1.2)
	await tween.finished
	
	# Truck has arrived: wobble warning board and play intro
	if animation_board != null:
		animation_board.play("board")
	Global.play(Global.SpeakType.STONE_INTRO)

func drive_away() -> void:
	# Dynamic exit animation: drive offscreen left
	var exit_target = Vector2(-size.x - 300, global_position.y)
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "global_position", exit_target, 1.4)
	await tween.finished
