extends CanvasLayer

var _start_label: Label
var _score_label: Label
var _speed_label: Label
var _game_over_label: Label
var _announcement_label: Label


func _ready() -> void:
	_start_label = $Control/StartLabel
	_score_label = $Control/ScoreLabel
	_speed_label = $Control/SpeedLabel
	_game_over_label = $Control/GameOverLabel
	_announcement_label = $Control/AnnouncementLabel


func _on_game_started() -> void:
	_start_label.show()
	_score_label.hide()
	_speed_label.hide()
	_game_over_label.hide()
	_announcement_label.hide()


func _on_level_started(level: int) -> void:
	_start_label.hide()
	_score_label.show()
	_speed_label.show()
	_game_over_label.hide()
	
	_show_announcement_label("Level %d" % level)


func _on_game_ended() -> void:
	_start_label.hide()
	_score_label.show()
	_speed_label.show()
	_game_over_label.show()
	_announcement_label.hide()


func _on_score_updated(score: int) -> void:
	_score_label.text = "Score: %d" % score


func _on_player_speed_updated(speed: float) -> void:
	# TODO: fix, function called before ready? (cannot use _speed_label directly)
	($Control/SpeedLabel as Label).text = "Speed: %.1f" % speed


func _on_player_maximum_speed_attained() -> void:
	_show_announcement_label("SURVIVE!")


func _show_announcement_label(text: String) -> void:
	_announcement_label.text = text
	_announcement_label.show()
	($AnnouncementHideTimer as Timer).start()
