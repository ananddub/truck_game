extends TextureButton

func _ready() -> void:
	toggle_mode = true
	# Sync visual toggle state with Global.sound on scene enter:
	# Global.sound == true  -> button_pressed = false (shows texture_normal: volumeon.png)
	# Global.sound == false -> button_pressed = true (shows texture_pressed: vaolumeoff.png)
	set_pressed_no_signal(!Global.sound)
	
	if not Global.sound_toggled.is_connected(_on_sound_toggled):
		Global.sound_toggled.connect(_on_sound_toggled)

func _exit_tree() -> void:
	if Global.sound_toggled.is_connected(_on_sound_toggled):
		Global.sound_toggled.disconnect(_on_sound_toggled)

func _on_sound_toggled(is_sound_on: bool) -> void:
	set_pressed_no_signal(!is_sound_on)

func _on_pressed() -> void:
	# toggle_mode has already updated button_pressed
	# button_pressed == true means muted (sound = false)
	# button_pressed == false means unmuted (sound = true)
	Global.set_sound(!button_pressed)
	
	# Tactile bounce feedback on click
	pivot_offset = size / 2.0
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.08)
	tween.tween_property(self, "scale", Vector2.ONE, 0.12)
