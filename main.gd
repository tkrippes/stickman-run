extends Node

enum GameState{
	GAME_STARTED,
	LEVEL_STARTED,
	LEVEL_ENDED,
	GAME_ENDED
}

signal score_updated(score: int)
signal game_started
signal level_started
signal level_ended
signal game_ended

var _game_state: GameState = GameState.GAME_STARTED
var _score: int = 0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_start_game()


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if (event as InputEventScreenTouch).pressed:
			_change_game_state()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("enter"):
		_change_game_state()


func _change_game_state() -> void:
	match _game_state:
			GameState.GAME_STARTED:
				_start_level()
			GameState.GAME_ENDED:
				_start_game()


func _on_player_scored() -> void:
	_score += 1
	score_updated.emit(_score)


func _start_game() -> void:
	_reset_score()
	_game_state = GameState.GAME_STARTED
	game_started.emit()


func _reset_score() -> void:
	_score = 0
	score_updated.emit(_score)


func _start_level() -> void:
	_game_state = GameState.LEVEL_STARTED
	level_started.emit()


func _end_level() -> void:
	_game_state = GameState.LEVEL_ENDED
	level_ended.emit()
	
	# TODO: change once there are multiple levels
	_end_game()


func _end_game() -> void:
	_game_state = GameState.GAME_ENDED
	game_ended.emit()
