class_name FormationStats extends Resource

@export_category("Structure")
@export var formation_shape: Formation.FormationShape = Formation.FormationShape.LINE_HORIZONTAL
@export var member_count: int = 5
@export var spacing: float = 40.0

@export_category("Movement")
@export var move_speed: float = 100.0
@export var move_direction: Vector2 = Vector2.LEFT
@export var rotation_speed: float = 0.0

@export_category("Enemy Type")
@export var enemy_scene: PackedScene
@export var enemy_stats: EnemyStats   # Base stats for all members; can be overridden per member

@export_category("Variation")
@export var randomize_stats: bool = false   # If true, each member gets slightly modified stats
@export var health_variance: float = 0.0    # e.g., 0.2 = ±20% health
@export var speed_variance: float = 0.0
