class_name HealthComponent extends Node

signal damaged(current_health: int, max_health: int, attacker: Node2D)
signal died(attacker: Node2D)

@export var max_health: int = 3
@export var current_health: int = 3
@export var invincible_duration: float = 0.5

var is_invincible: bool = false

var last_attacker: Node2D = null

func take_damage(amount: int = 1, attacker: Node2D = null) -> void:
    if is_invincible or current_health <= 0:
        return

    current_health = max(0, current_health - amount)
    if attacker != null:
        last_attacker = attacker

    damaged.emit(current_health, max_health, attacker)

    if current_health <= 0:
        died.emit(last_attacker)
    elif invincible_duration > 0:
        _start_invincibility()

func _start_invincibility() -> void:
    is_invincible = true
    await get_tree().create_timer(invincible_duration).timeout
    is_invincible = false
