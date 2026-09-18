extends Node2D

@onready var chota_bheem_friend: TextureRect = $CanvasLayer/background/chota_bheem_friend
@onready var toys: TextureRect = $CanvasLayer/background/toys
@onready var title: TextureRect = $CanvasLayer/background/title
@onready var cycle: TextureButton = $CanvasLayer/background/label/cycle
@onready var scoter: TextureButton = $CanvasLayer/background/label/scoter
@onready var car: TextureButton = $CanvasLayer/background/label/car
@onready var truck: TextureButton = $CanvasLayer/background/label/truck

func _ready() -> void:
	animate_background()
	animate_vehicles_cascade()

func animate_background() -> void:
	# Bheem and friends gentle breathing bob
	if chota_bheem_friend != null:
		chota_bheem_friend.pivot_offset = chota_bheem_friend.size / 2.0
		var orig_y = chota_bheem_friend.position.y
		var t := create_tween().set_loops()
		t.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		t.tween_property(chota_bheem_friend, "position:y", orig_y - 8.0, 1.3)
		t.tween_property(chota_bheem_friend, "position:y", orig_y, 1.3)
	
	# Toys gentle breathing float
	if toys != null:
		var orig_y = toys.position.y
		var t_toys := create_tween().set_loops()
		t_toys.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		t_toys.tween_property(toys, "position:y", orig_y - 5.0, 1.5)
		t_toys.tween_property(toys, "position:y", orig_y, 1.5)

	# Title pop-in and gentle tilt
	if title != null:
		title.pivot_offset = title.size / 2.0
		title.scale = Vector2.ZERO
		var t_title := create_tween()
		t_title.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		t_title.tween_property(title, "scale", Vector2.ONE, 0.6)
		await t_title.finished
		
		var t_loop := create_tween().set_loops()
		t_loop.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		t_loop.tween_property(title, "rotation_degrees", 2.0, 1.2)
		t_loop.tween_property(title, "rotation_degrees", -2.0, 1.2)

func animate_vehicles_cascade() -> void:
	var vehicles = [cycle, scoter, car, truck]
	for v in vehicles:
		if v != null:
			v.pivot_offset = v.size / 2.0
			v.scale = Vector2.ZERO
	
	# Staggered pop-in for vehicle cards
	for i in range(vehicles.size()):
		var v = vehicles[i]
		if v != null:
			await get_tree().create_timer(0.1).timeout
			var t := create_tween()
			t.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			t.tween_property(v, "scale", Vector2.ONE, 0.45)
