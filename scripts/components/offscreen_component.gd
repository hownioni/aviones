class_name OffscreenComponent extends Node

@export var margin: int = 50
@export var remove_on_exit: bool = true

func _process(delta: float) -> void:
	var parent = get_parent() as Node2D
	if not parent:
		return

	var viewport = parent.get_viewport_rect()
	var pos = parent.global_position

	if (
		pos.x < -margin or
		pos.x > viewport.size.x + margin or
		pos.y < -margin or
		pos.y > viewport.size.y + margin
		):
		if remove_on_exit:
			parent.queue_free()
		else:
			# Clamp to screen edges for players
			parent.global_position = pos.clamp(
				Vector2(margin, margin),
				Vector2(viewport.size.x - margin, viewport.size.y - margin)
			)
