extends Node

enum GameState {
	GAME_STARTED,
	GAME_RUNNING,
	GAME_OVER,
	GAME_WON
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
signal game_over
signal game_won
@export var level_2_unlock_score: int = 25
@export var level_3_unlock_score: int = 55
@export var level_4_unlock_score: int = 90
@export var game_won_score: int = 512

var _game_state: GameState = GameState.GAME_STARTED
var _level: Level          = Level.LEVEL_1
var _score: int            = 0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_start_game()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("enter"):
		_change_game_state()


func _change_game_state() -> void:
	match _game_state:
		GameState.GAME_STARTED:
			_start_level(_level)
		GameState.GAME_OVER:
			_start_game()


func _on_player_scored(points: int) -> void:
	_set_score(_score + points)

	if _level == Level.LEVEL_1 and _score >= level_2_unlock_score:
		_start_level(Level.LEVEL_2)
	elif _level == Level.LEVEL_2 and _score >= level_3_unlock_score:
		_start_level(Level.LEVEL_3)
	elif _level == Level.LEVEL_3 and _score >= level_4_unlock_score:
		_start_level(Level.LEVEL_4)
	elif _level == Level.LEVEL_4 and _score >= game_won_score:
		_game_won()


func _start_game() -> void:
	_game_state = GameState.GAME_STARTED

	game_started.emit()


func _start_level(level: Level) -> void:
	_game_state = GameState.GAME_RUNNING

	match level:
		Level.LEVEL_1:
			_set_score(0)
			_level = Level.LEVEL_1
			level_started.emit(1)
		Level.LEVEL_2:
			_set_score(level_2_unlock_score)
			_level = Level.LEVEL_2
			level_started.emit(2)
		Level.LEVEL_3:
			_set_score(level_3_unlock_score)
			_level = Level.LEVEL_3
			level_started.emit(3)
		Level.LEVEL_4:
			_set_score(level_4_unlock_score)
			_level = Level.LEVEL_4
			level_started.emit(4)


func _game_over() -> void:
	_game_state = GameState.GAME_OVER

	game_over.emit()

	
func _game_won() -> void:
	_game_state = GameState.GAME_WON

	game_won.emit()


func _set_score(score: int) -> void:
	_score = score
	score_updated.emit(_score)
