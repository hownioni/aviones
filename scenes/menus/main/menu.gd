extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    GameStateManager.current_state = GameStateManager.GameState.MENU
    Sql.crear_tablas()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _on_solo_game_pressed() -> void:
    GameModeManager.current_mode = GameModeManager.Mode.SINGLEPLAYER
    GameModeManager.reset_game()
    GameModeManager.set_player_name(0, "Solo Player")  # Default name
    get_tree().change_scene_to_file(ScenePaths.PACKED.GAME_WORLD)

func _on_duo_game_pressed() -> void:
    GameModeManager.current_mode = GameModeManager.Mode.COOP
    get_tree().change_scene_to_file(ScenePaths.MENUS.COOP_REGISTER)

func _on_versus_game_pressed() -> void:
    GameModeManager.current_mode = GameModeManager.Mode.VERSUS
    get_tree().change_scene_to_file(ScenePaths.MENUS.COOP_REGISTER)

func _on_ranking_pressed() -> void:
    get_tree().change_scene_to_file(ScenePaths.MENUS.RANKING)

func _on_salir_pressed() -> void:
    get_tree().quit()
