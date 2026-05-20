# scripts/game_manager.gd
extends Node

signal score_changed(new_score: int)
signal enemies_defeated_changed(count: int)

var current_score: int = 0:
	set(value):
		current_score = value
		score_changed.emit(current_score)

var enemies_defeated: int = 0:
	set(value):
		enemies_defeated = value
		enemies_defeated_changed.emit(enemies_defeated)

func add_score(amount: int) -> void:
	current_score += amount

func add_enemy_kill() -> void:
	enemies_defeated += 1

func reset_score() -> void:
	current_score = 0
	enemies_defeated = 0
