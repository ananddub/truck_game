extends TextureButton

var normal_scale := Vector2.ONE
var pressed_scale := Vector2(0.9, 0.9)

func _ready() -> void:
	scale = normal_scale

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/pick_truck.tscn")

func _on_button_down() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", pressed_scale, 0.09)

func _on_button_up() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", normal_scale, 0.1)
