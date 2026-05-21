extends Node

@onready var label_player_0: Label = %LabelPlayer0
@onready var label_player_1: Label = %LabelPlayer1
@onready var score_label: Label = %ScoreLabel
@onready var wave_manager: WaveManager = %WaveManager
@onready var wave_cleared_label: Label = %WaveClearedLabel
@onready var wave_label: Label = %WaveLabel

func _ready():
    # Connect UI
    ScoreManager.score_changed.connect(_on_score_changed)
    GameStateManager.game_ended.connect(_on_game_over)
    wave_manager.wave_started.connect(_on_wave_started)
    wave_manager.wave_cleared.connect(_on_wave_cleared)

    _start_game()

func _start_game():
    GameStateManager.start_game()
    wave_manager.start_game()

func _on_game_over(victory: bool):
    wave_manager.stop_game()

### UI ###
func _on_score_changed(new_score: int):
    score_label.text = "Score: %d" % new_score

func _on_player0_damaged(current_health: int, _max_health: int):
    label_player_0.text = "Jugador1: " + str(current_health)

func _on_player1_damaged(current_health: int, _max_health: int):
    label_player_1.text = "Jugador2: " + str(current_health)

func _on_wave_started(wave: int):
    wave_label.text = "Wave: %d" % wave

func _on_wave_cleared(wave: int):
    wave_cleared_label.show()
    wave_cleared_label.text = "Wave %d Cleared!" % wave
    await get_tree().create_timer(2.0).timeout
    wave_cleared_label.hide()
