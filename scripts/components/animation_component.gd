class_name AnimationComponent extends Node

@export var animated_sprite: AnimatedSprite2D
@export var default_animation: String = "default"

func play(animation_name: String = "") -> void:
	var anim = animation_name if not animation_name.is_empty() else default_animation
	if animated_sprite and animated_sprite.sprite_frames.has_animation(anim):
		animated_sprite.play(anim)

func stop() -> void:
	if animated_sprite:
		animated_sprite.stop()

func set_animation(animation_name: String) -> void:
	if animated_sprite and animated_sprite.sprite_frames.has_animation(animation_name):
		animated_sprite.animation = animation_name
