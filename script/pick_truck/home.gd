extends TextureButton

var normal_scale := Vector2.ONE
var pressed_scale := Vector2(0.9, 0.9)

func _ready() -> void:
	scale = normal_scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/home.tscn")
	
	


func _on_sound_pressed() -> void:
	pass # Replace with function body.
