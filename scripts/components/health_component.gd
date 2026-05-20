class_name HealthComponent extends Node

signal damaged(current_health: int, max_health: int)
signal died()

@export var max_health: int = 3
@export var current_health: int = 3
@export var invincible_duration: float = 0.5

var is_invincible: bool = false

func take_damage(amount: int = 1) -> void:
    if is_invincible or current_health <= 0:
        return

    current_health = max(0, current_health - amount)
    damaged.emit(current_health, max_health)

    if current_health <= 0:
        died.emit()
    elif invincible_duration > 0:
        _start_invincibility()

func _start_invincibility() -> void:
    is_invincible = true
    await get_tree().create_timer(invincible_duration).timeout
    is_invincible = false
