class_name HurtComponent extends Node

@export var damage: int = 1

func deal_damage(target: Node2D, attacker: Node2D = null):
    if target.has_method("take_damage"):
        target.take_damage(damage, attacker)

    _spawn_hit_effect(target.global_position)

func _spawn_hit_effect(position: Vector2):
    pass
