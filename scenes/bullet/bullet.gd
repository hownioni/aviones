extends Area2D

@export var speed := 300.0
@export var is_player_bullet := false
@export var damage: int = 1

@onready var offscreen_component: OffscreenComponent = %OffscreenComponent

var direction := Vector2.LEFT
var shooter: Node2D

func _ready() -> void:
    queue_redraw()
    area_entered.connect(_on_area_entered)
    body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
    position += direction * speed * delta

func _on_area_entered(area: Area2D):
    _handle_collision(area)

func _on_body_entered(body: Node2D):
    _handle_collision(body)

func _handle_collision(collider: Node2D):
    if collider == shooter:
        return

    if _can_damage(collider):
        _deal_damage(collider)
        queue_free()

func _can_damage(collider: Node2D) -> bool:
    # Enemy bullet vs Player
    if not is_player_bullet and collider is Player:
        return true

    # Player bullet vs Enemy
    if is_player_bullet and collider is Enemy:
        return true

    # Optional: Destructible objects
    if collider.has_method("take_damage"):
        return true

    return false

func _deal_damage(target: Node2D):
    if target.has_method("take_damage"):
        target.take_damage(damage)
    elif target.has_method("hit"):
        target.hit(damage)
    elif target.has_method("damage"):
        target.damage(damage)

    _spawn_hit_effect(target.global_position)

func _spawn_hit_effect(position: Vector2):
    pass

func _draw():
    # Color bullets differently based on owner
    if is_player_bullet:
        draw_circle(Vector2.ZERO, 2, Color.GREEN)
    else:
        draw_circle(Vector2.ZERO, 2, Color.RED)
