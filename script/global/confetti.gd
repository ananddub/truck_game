extends Node
## High-performance celebration confetti particle burst for task completion.

var canvas: CanvasLayer
var p_left: CPUParticles2D
var p_right: CPUParticles2D
var p_center: CPUParticles2D

func _ready() -> void:
	canvas = CanvasLayer.new()
	canvas.layer = 120 # Float above all UI elements
	add_child(canvas)

	# Create a crisp 14x22 rectangle ribbon particle texture
	var img := Image.create(14, 22, false, Image.FORMAT_RGBA8)
	img.fill(Color.WHITE)
	var tex := ImageTexture.create_from_image(img)

	# Rainbow celebration colors
	var grad := Gradient.new()
	grad.colors = PackedColorArray([
		Color("#FFD700"), # Gold
		Color("#FF4757"), # Coral Red
		Color("#2ED573"), # Vibrant Mint
		Color("#1E90FF"), # Dodger Blue
		Color("#FFA502"), # Orange Spark
		Color("#E056FD"), # Purple
		Color("#00D2D3"), # Bright Turquoise
		Color("#FF69B4")  # Hot Pink
	])
	grad.offsets = PackedFloat32Array([0.0, 0.14, 0.28, 0.42, 0.57, 0.71, 0.85, 1.0])

	# Left cannon shooting up-right
	p_left = _create_emitter(tex, grad, Vector2(180, 720), Vector2(1.1, -1.3), 55.0, 50)
	# Right cannon shooting up-left
	p_right = _create_emitter(tex, grad, Vector2(1740, 720), Vector2(-1.1, -1.3), 55.0, 50)
	# Center fountain shooting up
	p_center = _create_emitter(tex, grad, Vector2(960, 540), Vector2(0, -1.0), 90.0, 60)

	canvas.add_child(p_left)
	canvas.add_child(p_right)
	canvas.add_child(p_center)

func _create_emitter(tex: Texture2D, grad: Gradient, pos: Vector2, dir: Vector2, spread_deg: float, count: int) -> CPUParticles2D:
	var p := CPUParticles2D.new()
	p.position = pos
	p.texture = tex
	p.emitting = false
	p.one_shot = true
	p.amount = count
	p.lifetime = 2.4
	p.explosiveness = 0.9
	p.direction = dir.normalized()
	p.spread = spread_deg
	p.initial_velocity_min = 500.0
	p.initial_velocity_max = 950.0
	p.angular_velocity_min = -360.0
	p.angular_velocity_max = 360.0
	p.scale_amount_min = 0.9
	p.scale_amount_max = 1.7
	p.gravity = Vector2(0, 750)
	p.color_initial_ramp = grad
	return p

func burst() -> void:
	p_left.restart()
	p_right.restart()
	p_center.restart()
	p_left.emitting = true
	p_right.emitting = true
	p_center.emitting = true
