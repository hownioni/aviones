class_name Player extends Area2D

@export var player_id: int

@onready var input_component: InputComponent = %InputComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var animation_component: AnimationComponent = %AnimationComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var shooting_component: ShootingComponent = %ShootingComponent

func _ready() -> void:
    animation_component.play()
    input_component.player_id = player_id
    health_component.died.connect(_on_player_died)
    shooting_component.bullet_direction = Vector2.RIGHT

func _physics_process(delta: float) -> void:
    # Read input
    input_component.update()

    movement_component.direction = input_component.move_dir
    movement_component.tick(delta)

    if input_component.shoot_pressed:
        shooting_component.shoot(self)


    global_position = global_position.round()

func take_damage(amount: int) -> void:
    health_component.take_damage(amount)

func _on_player_died():
    print("Player %d died" % player_id)
