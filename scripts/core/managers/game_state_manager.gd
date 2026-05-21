extends Node
## Manages global game state (playing, paused, game over).

enum GameState {
    MENU,
    PLAYING,
    PAUSED,
    GAME_OVER,
    VICTORY
}

signal game_state_changed(old_state: GameState, new_state: GameState)
signal game_ended(victory: bool)

var current_state: GameState = GameState.MENU:
    set(value):
        if current_state == value:
            return
        var old_state = current_state
        current_state = value
        game_state_changed.emit(old_state, current_state)

var _players_alive: int = 0

func _ready():
    # Auto-detect players
    _update_players_alive()

func start_game():
    current_state = GameState.PLAYING
    get_tree().paused = false

func pause_game():
    if current_state == GameState.PLAYING:
        current_state = GameState.PAUSED
        get_tree().paused = true

func resume_game():
    if current_state == GameState.PAUSED:
        current_state = GameState.PLAYING
        get_tree().paused = false

func game_over(victory: bool = false):
    if victory:
        current_state = GameState.VICTORY
    else:
        current_state = GameState.GAME_OVER

    game_ended.emit(victory)
    get_tree().paused = true

func register_player_died(player_id: int = -1):
    if GameModeManager.current_mode == GameModeManager.Mode.VERSUS:
        game_over(true)
    else:
        _players_alive -= 1
        if _players_alive <= 0:
            game_over(false)

func register_player_spawned():
    _players_alive += 1

func _update_players_alive():
    var players = get_tree().get_nodes_in_group("players")
    _players_alive = players.size()
