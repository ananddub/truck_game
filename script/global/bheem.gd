extends Node
## Universal Bheem Bridge for Godot -> React Native
##
## Plug-and-play autoload that allows any Godot game to communicate with React Native:
##
## 1. Win / Score report:
##      Bheem.win(3, 400)
##      Bheem.win(3, 400, { "level": 1, "accuracy": 98 })
##
## 2. Any custom event/signal:
##      Bheem.send("coin_collected", { "amount": 10 })
##      Bheem.send("player_died", { "reason": "pit" })
##
## 3. Exit game activity back to React Native:
##      Bheem.exit()

func win(ladoos: int, xp: int, meta: Dictionary = {}) -> void:
	var data := meta.duplicate()
	data["ladoos"] = clampi(ladoos, 0, 3)
	data["xp"] = xp
	send("win", data)

func send(event_name: String, data: Dictionary = {}) -> void:
	if not Engine.has_singleton("BheemBridge"):
		print("[BheemBridge:Dev] Event: '", event_name, "' Data: ", data)
		return
	var bridge := Engine.get_singleton("BheemBridge")
	var json_str := JSON.stringify(data)
	if bridge.has_method("emit"):
		bridge.emit(event_name, json_str)
	elif bridge.has_method("submitResult") and event_name == "win":
		bridge.submitResult(data.get("ladoos", 0), data.get("xp", 0), json_str)

func exit() -> void:
	if not Engine.has_singleton("BheemBridge"):
		get_tree().quit()
		return
	var bridge := Engine.get_singleton("BheemBridge")
	if bridge.has_method("exit"):
		bridge.exit()
	else:
		get_tree().quit()
