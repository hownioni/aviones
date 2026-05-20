class_name ShootingComponent extends Node

@export var bullet_scene: PackedScene
var bullet_direction := Vector2.ZERO

func shoot(body: Node2D, spawn_offset: Vector2) -> void:
    if bullet_scene == null:
        return

    var bullet: Node2D = bullet_scene.instantiate()
    bullet.position = body.position + spawn_offset
    bullet.direction = bullet_direction
    body.get_parent().add_child(bullet)
