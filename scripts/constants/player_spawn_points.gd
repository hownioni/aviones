class_name PlayerSpawnPoints

static func get_spawn_position(player_id: int, viewport_size: Vector2, mode: int) -> Vector2:
    match mode:
        GameModeManager.Mode.SINGLEPLAYER:
            return Vector2(100, viewport_size.y / 2)
        GameModeManager.Mode.COOP:
            return Vector2(100, viewport_size.y / 2 + (-50 if player_id == 0 else 50))
        GameModeManager.Mode.VERSUS:
            return Vector2(100, viewport_size.y / 3 + (0 if player_id == 0 else viewport_size.y / 3))
        _:
            return Vector2(100, viewport_size.y / 2)
