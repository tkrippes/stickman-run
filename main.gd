extends Node

enum GameState {
	GAME_STARTED,
	GAME_RUNNING,
	GAME_ENDED
}

enum Level {
	LEVEL_1,
	LEVEL_2,
	LEVEL_3,
	LEVEL_4
}

signal score_updated(score: int)
signal game_started
signal level_started(level: int)
signal game_ended

@export var level_2_unlock_score: int = 30
@export var level_3_unlock_score: int = 60
@export var level_4_unlock_score: int = 90

var _game_state: GameState = GameState.GAME_STARTED
var _level: Level = Level.LEVEL_1
var _score: int = 0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_start_game()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("enter"):
		_change_game_state()


func _change_game_state() -> void:
	match _game_state:
			GameState.GAME_STARTED:
				_start_level(Level.LEVEL_1)
			GameState.GAME_ENDED:
				_start_game()


func _on_player_scored() -> void:
	_score += 1
	score_updated.emit(_score)
	
	if _score == level_2_unlock_score:
		_start_level(Level.LEVEL_2)
	elif _score == level_3_unlock_score:
		_start_level(Level.LEVEL_3)
	elif _score == level_4_unlock_score:
		_start_level(Level.LEVEL_4)


func _start_game() -> void:
	_reset_score()
	_game_state = GameState.GAME_STARTED
	game_started.emit()


func _reset_score() -> void:
	_score = 0
	score_updated.emit(_score)


func _start_level(level: Level) -> void:
	match level:
		Level.LEVEL_1:
			_game_state = GameState.GAME_RUNNING
			_level = Level.LEVEL_1
			level_started.emit(1)
		Level.LEVEL_2:
			_game_state = GameState.GAME_RUNNING
			_level = Level.LEVEL_2
			level_started.emit(2)
		Level.LEVEL_3:
			_game_state = GameState.GAME_RUNNING
			_level = Level.LEVEL_3
			level_started.emit(3)
		Level.LEVEL_4:
			_game_state = GameState.GAME_RUNNING
			_level = Level.LEVEL_4
			level_started.emit(4)


func _end_game() -> void:
	_game_state = GameState.GAME_ENDED
	game_ended.emit()
