class_name ShootingComponent extends Node

@export var bullet_scene: PackedScene
var bullet_direction := Vector2.ZERO

func shoot(body_pivot: Node2D) -> void:
	if bullet_scene == null:
		return

	var bullet: Node2D = bullet_scene.instantiate()
	bullet.position = body_pivot.position
	bullet.direction = bullet_direction
	body_pivot.get_parent().add_child(bullet)
