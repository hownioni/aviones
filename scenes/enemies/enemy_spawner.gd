extends Node2D

@export var enemy_scenes: Array[PackedScene]

var difficulty := "hard"

func _ready():
	randomize()
	start_spawn_loop()

func start_spawn_loop():
	while true:

		spawn_enemy()

		var wait_time = get_spawn_time()

		await get_tree().create_timer(wait_time).timeout

func spawn_enemy():

	var random_scene = enemy_scenes.pick_random()

	var enemy = random_scene.instantiate()

	var screen_width = get_viewport_rect().size.x

	var screen_size = get_viewport_rect().size

	enemy.position = Vector2(
		screen_size.x + 20,
		randf_range(10, screen_size.y - 10)
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
