class_name EnemyStats extends Resource

@export_category("Movement")
@export var speed: float = 100.0
@export var movement_type: MovementType = MovementType.STRAIGHT
@export var wave_frequency: float = 4.0

@export_category("Shooting")
@export var shooting_type: ShootingType = ShootingType.NONE
@export var shoot_delay: float = 1.0
@export var bullet_direction: Vector2 = Vector2.LEFT
@export var burst_count: int = 3
@export var burst_spread: float = 60.0  # degrees total spread

@export_category("Visual")
@export var sprite_frames: SpriteFrames
@export var default_animation: String = "default"
@export var sprite_scale: Vector2 = Vector2(1, 1)
@export var sprite_offset: Vector2 = Vector2.ZERO
@export var bullet_spawn_offset: Vector2 = Vector2.ZERO

@export_category("Collision")
@export var collision_radius: float = 8.0
@export var collision_shape: CapsuleShape2D
@export_range(-360, 360, 1.0, "radians_as_degrees") var collision_rotation: float = 0.0

enum MovementType {
	STRAIGHT,
	WAVE
}

enum ShootingType {
	NONE,
	SINGLE_SHOT,
	BURST
}
