extends "res://scenes/enemies/enemy_base.gd"

@export var bullet_scene: PackedScene

func _ready():
	super()

	start_shooting()

func start_shooting():
	while true:
		shoot()
		await get_tree().create_timer(1.0).timeout

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	bullet.direction = Vector2.LEFT
	get_parent().add_child(bullet)
