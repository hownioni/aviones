extends Area2D

@export var speed := 300.0
var direction := Vector2.LEFT

func _ready():
	monitoring = true
	monitorable = true

	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

	print("Bala lista")

func _process(delta):
	position += direction * speed * delta

	if (
		position.x < -100 or
		position.x > 2000 or
		position.y < -100 or
		position.y > 2000
	):
		queue_free()

func _draw():
	draw_circle(Vector2.ZERO, 1, Color.YELLOW)

func _on_area_entered(area):
	if area.is_in_group("enemies"):
		area.queue_free()
		queue_free()

	if area.is_in_group("players"):
		if area.has_method("take_damage"):
			area.take_damage(1)
		queue_free()

func _on_body_entered(body):
	print("Impacto con:", body.name)
	
	if body.is_in_group("enemies"):
		body.queue_free()
		queue_free()

	if body.is_in_group("players"):
		if body.has_method("take_damage"):
			body.take_damage(1)
		queue_free()
