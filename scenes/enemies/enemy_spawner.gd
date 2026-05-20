extends Node2D

@export var enemy_scene: PackedScene
@export var enemy_types: Array[EnemyStats]

var difficulty := "easy"

func _ready():
    randomize()
    start_spawn_loop()

func start_spawn_loop():
    while true:
        spawn_enemy()
        var wait_time = get_spawn_time()
        await get_tree().create_timer(wait_time).timeout

func spawn_enemy():
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

func get_spawn_time():
    match difficulty:
        "easy":
            return randf_range(1.5, 2.5)
        "normal":
            return randf_range(0.8, 1.5)
        "hard":
            return randf_range(0.3, 0.8)
    return 1.0
