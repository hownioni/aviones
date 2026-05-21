class_name WaveManager extends Node2D

# Signals
signal wave_started(wave_number: int)
signal wave_cleared(wave_number: int)
signal difficulty_changed(new_difficulty: String)
signal enemy_spawned(enemy: Enemy)
signal formation_spawned(formation: Formation)

@export_category("Setup")
@export var enemy_scene: PackedScene
@export var formation_scene: PackedScene
@export var enemy_types: Array[EnemyStats]
@export var formation_types: Array[FormationStats]

@export_category("Wave")
@export var formation_chance: float = 0.3
@export var enemies_per_wave: int = 10
@export var wave_transition_time: float = 3.0

var difficulty := "easy"

# Spawn timing (will be overridden by difficulty)
var _base_spawn_delay: Dictionary = {
    "easy": {"min": 1.5, "max": 2.5},
    "normal": {"min": 0.8, "max": 1.5},
    "hard": {"min": 0.3, "max": 0.8}
}

# State
var current_wave: int = 0
var current_difficulty: String = "easy"
var enemies_remaining_in_wave: int = 0
var _wave_in_progress: bool = false
var _spawning_enabled: bool = false
var _spawn_cancel: bool = false

func _ready():
    randomize()

func start_game():
    current_wave = 0
    _start_next_wave()

func stop_game():
    _spawning_enabled = false
    _wave_in_progress = false
    _spawn_cancel = true

func _start_next_wave():
    current_wave += 1
    _wave_in_progress = true
    enemies_remaining_in_wave = _calculate_enemies_for_wave()

    wave_started.emit(current_wave)
    _update_difficulty()
    _start_spawning()

func _calculate_enemies_for_wave() -> int:
    # More enemies each wave
    return enemies_per_wave + (current_wave - 1) * 2

func _update_difficulty():
    var new_difficulty = _get_difficulty_for_wave(current_wave)
    if new_difficulty != current_difficulty:
        current_difficulty = new_difficulty
        difficulty_changed.emit(current_difficulty)

func _get_difficulty_for_wave(wave: int) -> String:
    if wave <= 3:
        return "easy"
    elif wave <= 7:
        return "normal"
    else:
        return "hard"

func _start_spawning():
    _spawning_enabled = true
    _spawn_cancel = false
    _spawn_loop()

func _spawn_loop():
    while _spawning_enabled and enemies_remaining_in_wave > 0:
        # Decide to spawn formation or single enemy
        if randf() < formation_chance and formation_types.size() > 0:
            _spawn_formation()
        else:
            _spawn_single_enemy()

        enemies_remaining_in_wave -= 1

        # Wait before next spawn
        var wait_time = _get_spawn_delay()
        await get_tree().create_timer(wait_time).timeout

        # Check if wave was cleared externally (e.g., all enemies died)
        if not _wave_in_progress:
            break

    # Wave might have been cleared while spawning
    if _wave_in_progress and enemies_remaining_in_wave <= 0:
        _on_wave_cleared()

func _get_spawn_delay() -> float:
    var delays = _base_spawn_delay[current_difficulty]
    return randf_range(delays.min, delays.max)

func _spawn_single_enemy():
    if not enemy_scene or enemy_types.is_empty():
        return

    var enemy: Enemy = enemy_scene.instantiate()
    enemy.stats = enemy_types.pick_random()

    # Position at right edge of screen
    var screen_size = get_viewport_rect().size
    enemy.position = Vector2(
        screen_size.x + 20,
        randf_range(40, screen_size.y - 40)
    )

    add_child(enemy)
    enemy_spawned.emit(enemy)

func _spawn_formation():
    if not formation_scene or formation_types.is_empty():
        _spawn_single_enemy()  # Fallback
        return

    var formation: Formation = formation_scene.instantiate()
    formation.formation_stats = formation_types.pick_random()

    # Position formation at right edge
    var screen_size = get_viewport_rect().size
    formation.global_position = Vector2(
        screen_size.x + 50,
        randf_range(80, screen_size.y - 80)
    )

    add_child(formation)
    formation_spawned.emit(formation)

     # Listen for when formation members die
    formation.member_died.connect(_on_formation_member_died)

func _on_formation_member_died():
    # When a formation member dies, it still counts toward wave progress
    # This is called from Formation when any member dies
    enemies_remaining_in_wave -= 1

    if enemies_remaining_in_wave <= 0 and _wave_in_progress:
        _on_wave_cleared()

func _on_wave_cleared():
    _wave_in_progress = false
    _spawning_enabled = false
    wave_cleared.emit(current_wave)

    # Wait before next wave
    await get_tree().create_timer(wave_transition_time).timeout

    # Check if game is still active
    if not _spawn_cancel:
        _start_next_wave()

func on_enemy_killed():
    """Called by enemies when they die"""
    if _wave_in_progress:
        enemies_remaining_in_wave -= 1

        if enemies_remaining_in_wave <= 0:
            _on_wave_cleared()

# Public methods for external control
func skip_to_wave(wave_number: int):
    """For debugging or cheat codes"""
    current_wave = wave_number - 1
    if _wave_in_progress:
        _spawning_enabled = false
        await get_tree().process_frame
    _start_next_wave()

func set_custom_difficulty(difficulty: String, spawn_delays: Dictionary):
    """For custom game modes"""
    if _base_spawn_delay.has(difficulty):
        _base_spawn_delay[difficulty] = spawn_delays
    else:
        _base_spawn_delay[difficulty] = spawn_delays
