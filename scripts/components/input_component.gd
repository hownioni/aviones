class_name InputComponent extends Node

var player_id: int
var move_dir := Vector2.ZERO
var shoot_pressed := false

func update() -> void:
	move_dir = Input.get_vector(
		"move_left_%d" % player_id,
		"move_right_%d" % player_id,
		"move_up_%d" % player_id,
		"move_down_%d" % player_id
	)

	shoot_pressed = Input.is_action_just_pressed("shoot_%d" % player_id)
