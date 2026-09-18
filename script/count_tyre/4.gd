extends TextureButton

@onready var node = $"../../Node"

var idle_tween: Tween

func _ready() -> void:
	pivot_offset = size / 2.0
	start_idle()

func start_idle() -> void:
	idle_tween = create_tween().set_loops()
	idle_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	idle_tween.tween_property(self, "scale", Vector2(1.06, 1.06), 0.9)
	idle_tween.tween_property(self, "scale", Vector2.ONE, 0.9)

func _on_pressed() -> void:
	self.disabled = true
	if idle_tween != null:
		idle_tween.kill()
	
	var punch_tween := create_tween()
	punch_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	punch_tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.15)
	punch_tween.parallel().tween_property(self, "modulate", Color(1.3, 1.3, 1.1), 0.15)
	punch_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	punch_tween.tween_property(self, "scale", Vector2.ONE, 0.25)
	punch_tween.parallel().tween_property(self, "modulate", Color.WHITE, 0.25)
	
	node.on_pressed()
