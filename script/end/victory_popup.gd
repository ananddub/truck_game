extends Control

@onready var dim_bg: ColorRect = $DimBackground
@onready var modal_card: Panel = $ModalCard
@onready var laddoo_1: TextureRect = $ModalCard/InnerPlaque/StarsRow/Laddoo1
@onready var laddoo_2: TextureRect = $ModalCard/InnerPlaque/StarsRow/Laddoo2
@onready var laddoo_3: TextureRect = $ModalCard/InnerPlaque/StarsRow/Laddoo3
@onready var subtitle_label: Label = $ModalCard/InnerPlaque/Subtitle
@onready var back_btn: Button = $ModalCard/ButtonsRow/BackButton
@onready var play_again_btn: Button = $ModalCard/ButtonsRow/PlayAgainButton

var earned_stars: int = 3
var earned_xp: int = 300

func _ready() -> void:
	# Ensure full viewport bounds for root and backdrop
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if dim_bg != null:
		dim_bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		dim_bg.modulate = Color(1, 1, 1, 0)
	
	modal_card.modulate = Color(1, 1, 1, 0)
	modal_card.scale = Vector2(0.92, 0.92)
	modal_card.pivot_offset = modal_card.size / 2.0
	
	laddoo_1.scale = Vector2.ZERO
	laddoo_1.pivot_offset = laddoo_1.size / 2.0
	laddoo_2.scale = Vector2.ZERO
	laddoo_2.pivot_offset = laddoo_2.size / 2.0
	laddoo_3.scale = Vector2.ZERO
	laddoo_3.pivot_offset = laddoo_3.size / 2.0
	
	earned_stars = Progress.stars()
	earned_xp = Progress.xp()
	subtitle_label.text = "+%d XP! Bheem's truck is ready to roll!" % earned_xp
	
	# Dim unearned laddoos (matches RN opacity: 0.32)
	if earned_stars < 1:
		laddoo_1.modulate = Color(1, 1, 1, 0.32)
	if earned_stars < 2:
		laddoo_2.modulate = Color(1, 1, 1, 0.32)
	if earned_stars < 3:
		laddoo_3.modulate = Color(1, 1, 1, 0.32)
	
	# Slight pause so player sees victory celebration characters first
	await get_tree().create_timer(0.3).timeout
	show_modal()

func show_modal() -> void:
	if dim_bg != null:
		var t_dim := create_tween()
		t_dim.tween_property(dim_bg, "modulate:a", 1.0, 0.18)
	
	var t_card := create_tween()
	t_card.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	t_card.tween_property(modal_card, "scale", Vector2.ONE, 0.22)
	t_card.parallel().tween_property(modal_card, "modulate:a", 1.0, 0.20)
	await t_card.finished
	
	# Pop in laddoos sequentially (matching RN ThreeSmallLaddoos timing)
	var laddoos = [laddoo_1, laddoo_2, laddoo_3]
	var delays = [0.12, 0.22, 0.22]
	for i in range(laddoos.size()):
		var ld: TextureRect = laddoos[i]
		var t_ld := create_tween()
		t_ld.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		t_ld.tween_property(ld, "scale", Vector2.ONE, 0.28)
		if i + 1 <= earned_stars:
			Confetti.burst()
		await get_tree().create_timer(delays[i]).timeout

func _on_back_pressed() -> void:
	back_btn.disabled = true
	get_tree().change_scene_to_file("res://scene/home.tscn")

func _on_play_again_pressed() -> void:
	play_again_btn.disabled = true
	Progress.start_run()
	get_tree().change_scene_to_file("res://scene/pick_truck.tscn")
