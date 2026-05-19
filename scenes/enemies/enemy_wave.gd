extends "res://scenes/enemies/enemy_base.gd"

@export var bullet_scene: PackedScene

var time := 0.0
var base_y := 0.0

func _ready():
	super()
	base_y = position.y
	
	start_shooting()

func _process(delta):

	super(delta)

	time += delta

	position.y = base_y + sin(time * 4) * 20

	var screen_height = get_viewport_rect().size.y

	position.y = clamp(position.y, 5, screen_height - 5)
	
func start_shooting():
	while true:
		shoot()
		await get_tree().create_timer(1.0).timeout

func shoot():
	var angles = [-30, -15, 0, 15, 30]

	for angle in angles:

		var bullet = bullet_scene.instantiate()

		bullet.position = position

		bullet.direction = Vector2.LEFT.rotated(
			deg_to_rad(angle)
		)

		get_parent().add_child(bullet)
