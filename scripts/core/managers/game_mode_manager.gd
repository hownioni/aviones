extends Node

enum Mode { SINGLEPLAYER, COOP, VERSUS }

@export var current_mode: Mode = Mode.SINGLEPLAYER

# For Versus mode: store each player's score
var player_names: Dictionary = {}
var player_scores: Dictionary = {}  # player_id -> score

signal score_updated(player_id: int, new_score: int)

func _ready():
    reset_game()

func reset_game():
    player_scores.clear()
    # Initialize scores for both possible players
    player_scores[0] = 0
    player_scores[1] = 0

    player_names.clear()
    # Set default names
    player_names[0] = "Player 1"
    player_names[1] = "Player 2"

func set_player_name(player_id: int, name: String):
    player_names[player_id] = name

func get_player_name(player_id: int) -> String:
    return player_names.get(player_id, "Player " + str(player_id + 1))

func on_enemy_killed(attacker: Node2D, points: int):
    match current_mode:
        Mode.SINGLEPLAYER, Mode.COOP:
            # Both use global ScoreManager
            ScoreManager.add_points(points)
        Mode.VERSUS:
            if attacker is Player:
                var pid = attacker.player_id
                player_scores[pid] = player_scores.get(pid, 0) + points
                score_updated.emit(pid, player_scores[pid])

func get_player_score(player_id: int) -> int:
    return player_scores.get(player_id, 0)

func get_winner() -> int:
    if player_scores[0] > player_scores[1]:
        return 0
    elif player_scores[1] > player_scores[0]:
        return 1
    return -1  # Tie
