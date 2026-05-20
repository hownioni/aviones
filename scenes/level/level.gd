extends Node

@onready var label_player_0: Label = %LabelPlayer0
@onready var label_player_1: Label = %LabelPlayer1
@onready var score_label: Label = %ScoreLabel

func _ready():
    # Conectar señal de score
    GameManager.score_changed.connect(_on_score_changed)
    _on_score_changed(GameManager.current_score)

    # Buscar jugadores por grupo
    var players = get_tree().get_nodes_in_group("players")
    for player in players:
        if player.player_id == 0:
            player.health_component.damaged.connect(_on_player0_damaged)
            _on_player0_damaged(player.health_component.current_health, 0)
        elif player.player_id == 1:
            player.health_component.damaged.connect(_on_player1_damaged)
            _on_player1_damaged(player.health_component.current_health, 0)

func _on_score_changed(new_score: int):
    score_label.text = "Score: " + str(new_score)

func _on_player0_damaged(current_health: int, _max_health: int):
    label_player_0.text = "Jugador1: " + str(current_health)

func _on_player1_damaged(current_health: int, _max_health: int):
    label_player_1.text = "Jugador2: " + str(current_health)
