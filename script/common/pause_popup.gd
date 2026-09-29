extends CanvasLayer

@onready var dim_bg: ColorRect = $DimBackground
@onready var modal_card: Panel = $ModalCard
@onready var title_label: Label = $ModalCard/BannerRibbon/BannerText
@onready var subtitle_label: Label = $ModalCard/InnerPlaque/Subtitle
@onready var left_btn: Button = $ModalCard/ButtonsRow/LeftButton
@onready var resume_btn: Button = $ModalCard/ButtonsRow/ResumeButton

var mode: String = "gameplay"
var is_open: bool = false

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 100
	if dim_bg != null:
		dim_bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func show_pause(new_mode: String = "gameplay") -> void:
	if is_open:
		return
	is_open = true
	mode = new_mode
	
	if mode == "home":
		subtitle_label.text = "Do you want to continue playing or exit the game?"
		left_btn.text = "EXIT"
	else:
		subtitle_label.text = "Do you want to continue playing or go back to the home page?"
		left_btn.text = "BACK"
	
	visible = true
	left_btn.disabled = false
	resume_btn.disabled = false
	
	dim_bg.modulate = Color(1, 1, 1, 0)
	modal_card.modulate = Color(1, 1, 1, 0)
	modal_card.scale = Vector2(0.92, 0.92)
	modal_card.pivot_offset = modal_card.size / 2.0
	
	var t := create_tween()
	t.tween_property(dim_bg, "modulate:a", 1.0, 0.18)
	t.parallel().tween_property(modal_card, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	t.parallel().tween_property(modal_card, "modulate:a", 1.0, 0.20)

func hide_pause() -> void:
	if not is_open:
		return
	is_open = false
	var t := create_tween()
	t.tween_property(dim_bg, "modulate:a", 0.0, 0.15)
	t.parallel().tween_property(modal_card, "scale", Vector2(0.92, 0.92), 0.15)
	t.parallel().tween_property(modal_card, "modulate:a", 0.0, 0.15)
	await t.finished
	visible = false

func _on_left_button_pressed() -> void:
	left_btn.disabled = true
	if mode == "home":
		hide_pause()
		Bheem.exit()
		get_tree().quit()
	else:
		hide_pause()
		get_tree().change_scene_to_file("res://scene/home.tscn")

func _on_resume_button_pressed() -> void:
	resume_btn.disabled = true
	hide_pause()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		_handle_back_request()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_BACK:
		get_viewport().set_input_as_handled()
		_handle_back_request()

func _handle_back_request() -> void:
	if is_open:
		hide_pause()
	else:
		var cur_scene = get_tree().current_scene
		if cur_scene == null:
			return
		if cur_scene.name == "main":
			show_pause("home")
		elif cur_scene.name == "End":
			pass
		else:
			show_pause("gameplay")
