class_name HurtComponent extends Node

@export var damage: int = 1

func deal_damage(target: Node2D):
    if target.has_method("take_damage"):
        target.take_damage(damage)
    elif target.has_method("hit"):
        target.hit(damage)
    elif target.has_method("damage"):
        target.damage(damage)

    _spawn_hit_effect(target.global_position)

func _spawn_hit_effect(position: Vector2):
    pass
