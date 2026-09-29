extends Node
## Run scoring + the Android result bridge.
##
## Godot runs in its own process (`:godot` in the RN host app), so this autoload
## cannot call React directly. On the end scene it hands the finished run to the
## native `BheemBridge` plugin singleton, which broadcasts the result to the app's
## main process; React then submits ladoos + XP through the normal progress API.
## Outside Android (editor / web export) the singleton is absent and everything
## is a silent no-op — the game plays exactly the same.

const MIN_ACTIONS := 8 # 1 correct pick + 3 stones + 4 tyres

var start_ticks: int = 0
var wrong_picks: int = 0
var stone_presses: int = 0
var tyre_presses: int = 0
var submitted: bool = false

func start_run() -> void:
	start_ticks = Time.get_ticks_msec()
	wrong_picks = 0
	stone_presses = 0
	tyre_presses = 0
	submitted = false

func note_wrong_pick() -> void:
	wrong_picks += 1

func note_stone_press() -> void:
	stone_presses += 1

func note_tyre_press() -> void:
	tyre_presses += 1

## Stars map 1:1 to ladoos (server caps at 3, keeps the best, never downgrades).
func stars() -> int:
	if wrong_picks == 0:
		return 3
	if wrong_picks <= 2:
		return 2
	return 1

func elapsed_seconds() -> int:
	if start_ticks == 0:
		return 0
	return int(float(Time.get_ticks_msec() - start_ticks) / 1000.0)

## Higher = better run (the leaderboard sorts highest first).
## accuracy: perfect run (no wrong picks) = 100. speed: bonus for finishing fast.
func xp() -> int:
	var accuracy := int(round(100.0 * MIN_ACTIONS / max(float(MIN_ACTIONS + wrong_picks), float(MIN_ACTIONS))))
	var speed := int(max(0, 60 - elapsed_seconds()) * 2)
	return stars() * 100 + accuracy + speed

## Called once from the end scene — the moment the player has won.
func submit_result() -> void:
	if submitted:
		return
	submitted = true
	var meta := {
		"seconds": elapsed_seconds(),
		"stars": stars(),
		"wrongPicks": wrong_picks,
		"stonePresses": stone_presses,
		"tyrePresses": tyre_presses,
	}
	Bheem.win(stars(), xp(), meta)
