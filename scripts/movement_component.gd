class_name MovementComponent extends Node

@export var body: Area2D
@export var sprite: Node2D
@export var speed := 200.0

var direction := Vector2.ZERO

func tick(delta: float) -> void:
	if body == null:
		return

	if direction:
		body.global_position += direction * speed * delta
