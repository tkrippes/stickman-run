extends CanvasLayer

var _start_label: Label
var _score_label: Label
var _speed_label: Label
var _game_ended_label: Label
var _level_announcement_label: Label
var _survive_announcement_label: Label


func _ready() -> void:
	_start_label = $Control/StartLabel
	_score_label = $Control/ScoreLabel
	_speed_label = $Control/SpeedLabel
	_game_ended_label = $Control/GameEndedLabel
	_level_announcement_label = $Control/LevelAnnouncementLabel
	_survive_announcement_label = $Control/SurviveAnnouncementLabel


func _on_game_started() -> void:
	_start_label.show()
	_score_label.hide()
	_speed_label.hide()
	_game_ended_label.hide()
	_level_announcement_label.hide()
	_survive_announcement_label.hide()


func _on_level_started(level: int) -> void:
	_start_label.hide()
	_score_label.show()
	_speed_label.show()
	_game_ended_label.hide()
	
	_show_level_announcement_label(level)


func _on_game_over() -> void:
	_start_label.hide()
	_score_label.show()
	_speed_label.show()
	_game_ended_label.text = "Game Over!"
	_game_ended_label.show()
	_level_announcement_label.hide()
	_survive_announcement_label.hide()
	
	
func _on_game_won() -> void:
	_start_label.hide()
	_score_label.show()
	_speed_label.show()
	_game_ended_label.text = "You Win!"
	_game_ended_label.show()
	_level_announcement_label.hide()
	_survive_announcement_label.hide()
	
	
func _on_secret_end() -> void:
	_start_label.hide()
	_score_label.hide()
	_speed_label.hide()
	_game_ended_label.hide()
	_level_announcement_label.hide()
	_survive_announcement_label.hide()
	
	
func _on_player_fell() -> void:
	_game_ended_label.text = "You Died!"
	_game_ended_label.show()


func _on_score_updated(score: int) -> void:
	_score_label.text = "Score: %d" % score


func _on_player_speed_updated(speed: float) -> void:
	# TODO: fix, function called before ready? (cannot use _speed_label directly)
	($Control/SpeedLabel as Label).text = "Speed: %.1f" % speed


func _on_player_maximum_speed_attained() -> void:
	_show_survive_announcement_label()


func _show_level_announcement_label(level: int) -> void:
	_level_announcement_label.text = "Level %d" % level
	_level_announcement_label.show()
	($LevelAnnouncementHideTimer as Timer).start()


func _show_survive_announcement_label() -> void:
	_survive_announcement_label.show()
	($SurviveAnnouncementHideTimer as Timer).start()
