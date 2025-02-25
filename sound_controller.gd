class_name SoundController
extends Node

@export var level_started_pitch_per_level: float = 0.2

var _background_music: AudioStreamPlayer
var _level_started_sound: AudioStreamPlayer
var _survive_sound: AudioStreamPlayer
var _game_over_sound: AudioStreamPlayer


func _ready() -> void:
	_background_music = $BackgroundMusic
	_level_started_sound = $LevelStartedSound
	_survive_sound = $SurviveSound
	_game_over_sound = $GameOverSound


func start_background_music() -> void:
	_level_started_sound.stop()
	_survive_sound.stop()
	_game_over_sound.stop()
	_background_music.play()


func play_level_started_sound(_level: int) -> void:
	_level_started_sound.pitch_scale = 1.0 + (_level - 1) * level_started_pitch_per_level
	_level_started_sound.play()


func play_survive_sound() -> void:
	_survive_sound.play()


func play_game_over_sound() -> void:
	_background_music.stop()
	_level_started_sound.stop()
	_survive_sound.stop()
	_game_over_sound.play()
	
	
