class_name Player extends Area2D

signal health_changed(current_health: int, max_health: int)

@export var player_id: int
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var input_component: InputComponent = %InputComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var animation_component: AnimationComponent = %AnimationComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var shooting_component: ShootingComponent = %ShootingComponent
@onready var vfx_component: VfxComponent = %VfxComponent

func _ready() -> void:
    animation_component.play()
    input_component.player_id = player_id
    shooting_component.bullet_direction = Vector2.RIGHT
    GameStateManager.register_player_spawned()
    add_to_group("players")

func get_team() -> Team.Type:
    return Team.Type.PLAYER

func _physics_process(delta: float) -> void:
    # Read input
    input_component.update()

    movement_component.direction = input_component.move_dir
    movement_component.tick(delta)

    if input_component.shoot_pressed:
        shooting_component.shoot(self)


    global_position = global_position.round()

func take_damage(amount: int, _attacker: Node2D) -> void:
    health_component.take_damage(amount)

func _on_player_died(_attacker: Node2D) -> void:
    print("Player %d died" % player_id)
    #collision_shape_2d.disabled = true
    #set_physics_process(false)
    GameStateManager.register_player_died(player_id)

    # Optional: play death animation or particle effect here
    await get_tree().create_timer(0.2).timeout
    queue_free()

func _on_player_damaged(current_health: int, max_health: int, attacker: Node2D) -> void:
    health_changed.emit(current_health, max_health)
    vfx_component.flash()
