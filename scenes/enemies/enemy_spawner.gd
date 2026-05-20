extends Node2D

@export var enemy_scene: PackedScene
@export var enemy_types: Array[EnemyStats]
@export var formation_scene: PackedScene
@export var use_formations: bool = true
@export var formation_chance: float = 0.3

var difficulty := "easy"

func _ready():
	randomize()
	start_spawn_loop()

func start_spawn_loop():
    while true:
        if use_formations and randf() < formation_chance:
            spawn_formation()
        else:
            spawn_single_enemy()

        var wait_time = get_spawn_time()
        await get_tree().create_timer(wait_time).timeout

@export var formation_types: Array[FormationStats]   # List of possible formations

func spawn_formation():
    var formation_stats = formation_types.pick_random()
    var formation: Formation = formation_scene.instantiate()
    formation.formation_stats = formation_stats
    # Position formation at right edge
    var screen_size = get_viewport_rect().size
    formation.global_position = Vector2(screen_size.x + 50, randf_range(80, screen_size.y - 80))
    add_child(formation)

func spawn_single_enemy():
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
