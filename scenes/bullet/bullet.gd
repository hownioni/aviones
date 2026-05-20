extends Area2D

@export var speed := 300.0

var direction := Vector2.LEFT

#para saber quine disparo la balita
var owner_player_id : int

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

func _ready():
	queue_redraw()
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area):
	if area is Enemy:
		area.die(owner_player_id)
		queue_free()
