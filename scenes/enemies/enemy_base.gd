extends Area2D

@export var speed := 100.0
var direction := Vector2.LEFT

func _process(delta):
	position += direction * speed * delta
	
	if position.x < -20:
		queue_free()

func _draw():
	draw_circle(Vector2.ZERO, 5, Color.RED)

func _ready():
	queue_redraw()
	
