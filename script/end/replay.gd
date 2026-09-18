extends TextureButton

func _ready() -> void:
	Global.play(Global.SpeakType.END_CELEBRATION)

func _on_pressed() -> void:
	disabled = true
	await Global.play_and_wait(Global.SpeakType.END_REPLAY_CLICK, 0.4)
	get_tree().change_scene_to_file("res://scene/home.tscn")
