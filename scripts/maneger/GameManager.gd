extends Node

signal score_changed(player_id, new_score)
var player_scores := {}


func register_player(player_id: int):
	if not player_scores.has(player_id):
		player_scores[player_id] = 0


func add_score(player_id: int, amount: int):
	if not player_scores.has(player_id):
		register_player(player_id)
	player_scores[player_id] += amount
	score_changed.emit(
		player_id,
		player_scores[player_id]
	)

func get_score(player_id: int) -> int:
	if not player_scores.has(player_id):
		return 0
	return player_scores[player_id]

func reset_scores():
	for id in player_scores.keys():
		player_scores[id] = 0
		score_changed.emit(id, 0)


func clear_all():
	for id in player_scores.keys():
		score_changed.emit(id, 0)
	player_scores.clear()
