extends Area2D

@export var player_id: int

const SPEED = 200
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    animated_sprite_2d.play("default")


func _physics_process(delta: float) -> void:
    var input_dir = Input.get_vector("move_left_%d" % player_id, "move_right_%d" % player_id, "move_up_%d" % player_id, "move_down_%d" % player_id)

    if input_dir:
        global_position += input_dir * SPEED * delta

    global_position = global_position.round()
