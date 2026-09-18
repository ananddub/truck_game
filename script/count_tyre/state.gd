extends Node

var count: int = 0
@onready var scene_root = $"../../.."

func _ready() -> void:
	Global.play(Global.SpeakType.TYRE_INTRO)

func on_pressed() -> void:
	count += 1
	if scene_root != null and scene_root.has_method("on_tyre_counted"):
		scene_root.on_tyre_counted(count)
	
	if count == 1:
		Global.play(Global.SpeakType.TYRE_COUNT_1)
	elif count == 2:
		Global.play(Global.SpeakType.TYRE_COUNT_2)
	elif count == 3:
		Global.play(Global.SpeakType.TYRE_COUNT_3)
	elif count == 4:
		await Global.play_and_wait(Global.SpeakType.TYRE_COUNT_4, 0.5)
		get_tree().change_scene_to_file("res://scene/end.tscn")
