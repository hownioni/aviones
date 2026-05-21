extends Node2D


@onready var player_0_name_label: Label = %Player0NameLabel
@onready var player_1_name_label: Label = %Player1NameLabel
@onready var wave_label: Label = %WaveLabel
@onready var player_0_score_label: Label = %Player0ScoreLabel
@onready var player_1_score_label: Label = %Player1ScoreLabel
@onready var score_label: Label = %ScoreLabel
@onready var wave_cleared_label: Label = %WaveClearedLabel
@onready var wave_manager: WaveManager = %WaveManager

# References to spawned players
var _players: Array[Player] = []

func _ready():
    _spawn_players()

    # Connect UI
    ScoreManager.score_changed.connect(_on_score_changed)
    GameModeManager.score_updated.connect(_on_player_score_updated)
    GameStateManager.game_ended.connect(_on_game_over)
    wave_manager.wave_started.connect(_on_wave_started)
    wave_manager.wave_cleared.connect(_on_wave_cleared)

    # Connect player-specific signals if they exist
    _connect_player_signals()

    _update_ui_for_mode()
    _start_game()

func _spawn_players():
    var mode = GameModeManager.current_mode

    # Load player scenes
    var player_scene_0 = load(ScenePaths.PACKED.OBJECTS.PLAYER_0)
    var player_scene_1 = load(ScenePaths.PACKED.OBJECTS.PLAYER_1)
    var player_0: Player
    var player_1: Player
    var viewport_size = get_viewport_rect().size

    # Spawn only Player 0
    player_0 = player_scene_0.instantiate()
    player_0.player_id = 0
    add_child(player_0)
    _players.append(player_0)

    player_0.position = PlayerSpawnPoints.get_spawn_position(0, viewport_size, mode)

    if mode == GameModeManager.Mode.SINGLEPLAYER:
        # Hide Player 1 UI elements
        player_1_name_label.visible = false
        player_1_score_label.visible = false
    else:
        player_1 = player_scene_1.instantiate()
        player_1.player_id = 1
        add_child(player_1)
        _players.append(player_1)
        player_1.position = PlayerSpawnPoints.get_spawn_position(1, viewport_size, mode)

func _connect_player_signals():
    # Find players and connect their health signals if they have them
    for player in _players:
        if player.has_signal("health_changed"):
            player.health_changed.connect(_on_player_health_changed.bind(player.player_id))

func _update_ui_for_mode():
    var mode = GameModeManager.current_mode
    var is_multiplayer = (mode == GameModeManager.Mode.COOP or mode == GameModeManager.Mode.VERSUS)
    var is_versus = (mode == GameModeManager.Mode.VERSUS)

    # Show/hide player labels based on mode
    player_0_name_label.visible = is_multiplayer
    player_1_name_label.visible = is_multiplayer
    player_0_score_label.visible = is_versus
    player_1_score_label.visible = is_versus
    score_label.visible = (mode == GameModeManager.Mode.SINGLEPLAYER or mode == GameModeManager.Mode.COOP)

    # Set player names in UI
    if is_multiplayer:
        player_0_name_label.text = GameModeManager.get_player_name(0)
        player_1_name_label.text = GameModeManager.get_player_name(1)

func _start_game():
    GameStateManager.start_game()
    wave_manager.start_game()

func _on_game_over(victory: bool):
    wave_manager.stop_game()
    _save_scores_to_database()
    await get_tree().create_timer(2.0).timeout
    get_tree().paused = false
    get_tree().change_scene_to_file(ScenePaths.MENUS.MAIN)

func _save_scores_to_database():
    var mode = GameModeManager.current_mode
    match mode:
        GameModeManager.Mode.SINGLEPLAYER:
            Sql.insertar_score(GameModeManager.get_player_name(0), ScoreManager.current_score)
        GameModeManager.Mode.COOP:
            # Shared score - save for both players
            var shared_score = ScoreManager.current_score
            Sql.insertar_score(GameModeManager.get_player_name(0), shared_score)
            Sql.insertar_score(GameModeManager.get_player_name(1), shared_score)
        GameModeManager.Mode.VERSUS:
            Sql.insertar_score(GameModeManager.get_player_name(0), GameModeManager.get_player_score(0))
            Sql.insertar_score(GameModeManager.get_player_name(1), GameModeManager.get_player_score(1))

### UI ###
func _on_score_changed(new_score: int):
    score_label.text = "Score: %d" % new_score

func _on_player_score_updated(player_id: int, new_score: int):
    if player_id == 0:
        player_0_score_label.text = "%s: %d" % [GameModeManager.get_player_name(0), new_score]
    else:
        player_1_score_label.text = "%s: %d" % [GameModeManager.get_player_name(1), new_score]

func _on_player_health_changed(current_health: int, player_id: int):
    # You need to add a health_changed signal to HealthComponent first
    if player_id == 0:
        player_0_name_label.text = GameModeManager.get_player_name(0) + ": " + str(current_health)
    else:
        player_1_name_label.text = GameModeManager.get_player_name(1) + ": " + str(current_health)

func _on_wave_started(wave: int):
    wave_label.text = "Wave: %d" % wave

func _on_wave_cleared(wave: int):
    wave_cleared_label.show()
    wave_cleared_label.text = "Wave %d Cleared!" % wave
    await get_tree().create_timer(2.0).timeout
    wave_cleared_label.hide()
