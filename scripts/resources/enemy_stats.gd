class_name EnemyStats extends Resource

@export_category("Movement")
@export var speed: float = 100.0
@export var movement_type: MovementType = MovementType.STRAIGHT
@export var wave_frequency: float = 4.0
@export var wave_amplitude: float = 50.0

@export_category("Shooting")
@export var shooting_type: ShootingType = ShootingType.NONE
@export var shoot_delay: float = 1.0
@export var bullet_direction: Vector2 = Vector2.LEFT
@export var burst_count: int = 3
@export var burst_spread: float = 60.0  # degrees total spread

@export_category("Visual")
@export var color: Color = Color.RED
@export var radius: float = 5.0
@export var show_weapon_indicators: bool = true

enum MovementType {
    STRAIGHT,
    WAVE
}

enum ShootingType {
    NONE,
    SINGLE_SHOT,
    BURST
}
