extends Node

signal sound_toggled(is_sound_on: bool)

const SETTINGS_FILE = "user://settings.cfg"

var sound: bool = true
var audio_player: AudioStreamPlayer
var bgm_player: AudioStreamPlayer
const BGM_STREAM = preload("res://assets/sounds/bgm.mp3")

enum SpeakType {
	HOME_WELCOME,
	HOME_PLAY_PROMPT,
	HOME_IDLE,
	HOME_PLAY_CLICK,
	PICK_INTRO,
	PICK_IDLE,
	PICK_WRONG_CYCLE,
	PICK_WRONG_SCOOTER,
	PICK_WRONG_CAR,
	PICK_CORRECT_TRUCK,
	STONE_INTRO,
	STONE_IDLE,
	STONE_REMOVE_1,
	STONE_REMOVE_2,
	STONE_REMOVE_3,
	TYRE_INTRO,
	TYRE_IDLE,
	TYRE_COUNT_1,
	TYRE_COUNT_2,
	TYRE_COUNT_3,
	TYRE_COUNT_4,
	END_CELEBRATION,
	END_IDLE,
	END_REPLAY_CLICK,
	END_HOME_CLICK
}

const SOUNDS = {
	SpeakType.HOME_WELCOME: preload("res://assets/sounds/tts/home_welcome.mp3"),
	SpeakType.HOME_PLAY_PROMPT: preload("res://assets/sounds/tts/home_play_prompt.mp3"),
	SpeakType.HOME_IDLE: preload("res://assets/sounds/tts/home_idle.mp3"),
	SpeakType.HOME_PLAY_CLICK: preload("res://assets/sounds/tts/home_play_click.mp3"),
	SpeakType.PICK_INTRO: preload("res://assets/sounds/tts/pick_intro.mp3"),
	SpeakType.PICK_IDLE: preload("res://assets/sounds/tts/pick_idle.mp3"),
	SpeakType.PICK_WRONG_CYCLE: preload("res://assets/sounds/tts/pick_wrong_cycle.mp3"),
	SpeakType.PICK_WRONG_SCOOTER: preload("res://assets/sounds/tts/pick_wrong_scooter.mp3"),
	SpeakType.PICK_WRONG_CAR: preload("res://assets/sounds/tts/pick_wrong_car.mp3"),
	SpeakType.PICK_CORRECT_TRUCK: preload("res://assets/sounds/tts/pick_correct_truck.mp3"),
	SpeakType.STONE_INTRO: preload("res://assets/sounds/tts/stone_intro.mp3"),
	SpeakType.STONE_IDLE: preload("res://assets/sounds/tts/stone_idle.mp3"),
	SpeakType.STONE_REMOVE_1: preload("res://assets/sounds/tts/stone_remove_1.mp3"),
	SpeakType.STONE_REMOVE_2: preload("res://assets/sounds/tts/stone_remove_2.mp3"),
	SpeakType.STONE_REMOVE_3: preload("res://assets/sounds/tts/stone_remove_3.mp3"),
	SpeakType.TYRE_INTRO: preload("res://assets/sounds/tts/tyre_intro.mp3"),
	SpeakType.TYRE_IDLE: preload("res://assets/sounds/tts/tyre_idle.mp3"),
	SpeakType.TYRE_COUNT_1: preload("res://assets/sounds/tts/tyre_count_1.mp3"),
	SpeakType.TYRE_COUNT_2: preload("res://assets/sounds/tts/tyre_count_2.mp3"),
	SpeakType.TYRE_COUNT_3: preload("res://assets/sounds/tts/tyre_count_3.mp3"),
	SpeakType.TYRE_COUNT_4: preload("res://assets/sounds/tts/tyre_count_4.mp3"),
	SpeakType.END_CELEBRATION: preload("res://assets/sounds/tts/end_celebration.mp3"),
	SpeakType.END_IDLE: preload("res://assets/sounds/tts/end_idle.mp3"),
	SpeakType.END_REPLAY_CLICK: preload("res://assets/sounds/tts/end_replay_click.mp3"),
	SpeakType.END_HOME_CLICK: preload("res://assets/sounds/tts/end_home_click.mp3"),
}

func _ready() -> void:
	load_settings()
	audio_player = AudioStreamPlayer.new()
	audio_player.name = "AudioPlayer"
	audio_player.bus = "Master"
	add_child(audio_player)

	bgm_player = AudioStreamPlayer.new()
	bgm_player.name = "BgmPlayer"
	bgm_player.bus = "Master"
	bgm_player.volume_db = -12.0
	bgm_player.stream = BGM_STREAM
	add_child(bgm_player)
	bgm_player.finished.connect(func():
		if sound and bgm_player != null:
			bgm_player.play()
	)

	apply_sound_state()

func load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_FILE)
	if err == OK:
		sound = config.get_value("audio", "sound", true)
	else:
		sound = true

func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "sound", sound)
	config.save(SETTINGS_FILE)

func set_sound(is_on: bool) -> void:
	sound = is_on
	save_settings()
	apply_sound_state()
	sound_toggled.emit(sound)

func apply_sound_state() -> void:
	# Only BGM is toggled by the volume button!
	# Narration and gameplay SFX continue playing.
	if bgm_player != null:
		if sound:
			if not bgm_player.playing:
				bgm_player.play()
		else:
			bgm_player.stop()

func toogle() -> void:
	set_sound(!sound)

func toggle() -> void:
	toogle()

func stop() -> void:
	if audio_player != null and audio_player.playing:
		audio_player.stop()

func play(type: SpeakType) -> void:
	# Narration/TTS always plays
	if SOUNDS.has(type):
		if audio_player == null:
			audio_player = AudioStreamPlayer.new()
			audio_player.name = "AudioPlayer"
			audio_player.bus = "Master"
			add_child(audio_player)
		audio_player.stop()
		audio_player.stream = SOUNDS[type]
		audio_player.play()

func wait_for_speech() -> void:
	if audio_player == null:
		return
	if audio_player.playing:
		await audio_player.finished

func play_and_wait(type: SpeakType, extra_delay: float = 0.3) -> void:
	play(type)
	await wait_for_speech()
	if extra_delay > 0:
		await get_tree().create_timer(extra_delay).timeout
