extends TextureButton

@onready var game = $"../../Node"
@onready var stone_position_3: TextureRect = $"../card/stone_position3"

var idle_tween: Tween

func _ready() -> void:
	pivot_offset = size / 2.0
	start_idle_hint()

func start_idle_hint() -> void:
	idle_tween = create_tween().set_loops()
	idle_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	idle_tween.tween_property(self, "scale", Vector2(1.05, 1.05), 1.2)
	idle_tween.tween_property(self, "scale", Vector2.ONE, 1.2)

func _on_pressed() -> void:
	disabled = true
	if idle_tween != null:
		idle_tween.kill()
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
	# Pop punch up
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.15)
	tween.parallel().tween_property(self, "rotation_degrees", -15.0, 0.15)
	# Fly to target
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", target_pos, 0.65)
	tween.parallel().tween_property(self, "scale", final_scale, 0.65)
	tween.parallel().tween_property(self, "rotation_degrees", 0.0, 0.65)
	await tween.finished
	game._on_pressed()
