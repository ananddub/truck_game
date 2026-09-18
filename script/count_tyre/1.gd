extends TextureButton



@onready var node = $"../../Node"

func _on_pressed() -> void:
	self.disabled = true
	node.on_pressed()
