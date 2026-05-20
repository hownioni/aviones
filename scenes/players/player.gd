class_name Player extends Area2D

@export var player_id: int

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var input_component: InputComponent = %InputComponent
@onready var movement_component: MovementComponent = %MovementComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("default")
	input_component.player_id = player_id
	GameManager.register_player(player_id)


func _physics_process(delta: float) -> void:
	# Read input
	input_component.update()

	movement_component.direction = input_component.move_dir
	movement_component.tick(delta)


	global_position = global_position.round()
