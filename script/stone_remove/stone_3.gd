extends TextureButton

@onready var game = $"../../Node"
@onready var stone_position_3: TextureRect = $"../card/stone_position3"

func _on_pressed() -> void:
	disabled = true
	Global.play(Global.SpeakType.STONE_REMOVE_3)
	animate_to_target(stone_position_3)

func animate_to_target(target_node: Control) -> void:
	var final_scale := Vector2(0.75, 0.75)
	var target_pos: Vector2
	if target_node != null:
		var target_center = target_node.global_position + (target_node.size / 2.0)
		target_pos = target_center - ((size * final_scale) / 2.0)
	else:
		target_pos = global_position
	
	var tween := create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", target_pos, 0.8)
	tween.tween_property(self, "scale", final_scale, 0.8)
	await tween.finished
	game._on_pressed()
