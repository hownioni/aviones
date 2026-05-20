# enemy.gd
class_name Enemy extends Area2D

@export var stats: EnemyStats

@onready var movement_component: MovementComponent = %MovementComponent
@onready var shooting_component: ShootingComponent = %ShootingComponent
@onready var shoot_timer: Timer = $ShootTimer

var _wave_time: float = 0.0

func _ready():
	if not stats:
		_enable_debug_mode()
		return

	movement_component.speed = stats.speed

	# Setup shooting timer
	if stats.shooting_type != EnemyStats.ShootingType.NONE:
		shoot_timer.wait_time = stats.shoot_delay
		shoot_timer.timeout.connect(_on_shoot_timer_timeout)
		shoot_timer.start()

	queue_redraw()

func _physics_process(delta: float):
	if not stats:
		return

	# Movement only - shooting handled by timer
	match stats.movement_type:
		EnemyStats.MovementType.STRAIGHT:
			movement_component.direction = Vector2.LEFT

		EnemyStats.MovementType.WAVE:
			_wave_time += delta
			var wave_direction = Vector2.LEFT
			wave_direction.y = sin(_wave_time * stats.wave_frequency) * (stats.wave_amplitude / stats.speed)
			movement_component.direction = wave_direction.normalized()

	movement_component.tick(delta)

	# Off-screen removal
	if position.x < -50:
		queue_free()

	# Clamp wave enemies
	if stats.movement_type == EnemyStats.MovementType.WAVE:
		var viewport = get_viewport_rect()
		position.y = clamp(position.y, 20, viewport.size.y - 20)

func _on_shoot_timer_timeout():
	match stats.shooting_type:
		EnemyStats.ShootingType.SINGLE_SHOT:
			_shoot_single()
		EnemyStats.ShootingType.BURST:
			_shoot_burst()

func _shoot_single():
	shooting_component.bullet_direction = stats.bullet_direction
	shooting_component.shoot(self)

func _shoot_burst():
	if stats.burst_count <= 1:
		_shoot_single()
		return

	var angle_step = stats.burst_spread / (stats.burst_count - 1)
	var start_angle = -stats.burst_spread / 2

	for i in range(stats.burst_count):
		var angle_deg = start_angle + (angle_step * i)
		var direction = stats.bullet_direction.rotated(deg_to_rad(angle_deg))
		shooting_component.bullet_direction = direction
		shooting_component.shoot(self)

# Optional: Stop shooting when enemy dies
func die():
	shoot_timer.stop()
	queue_free()

func _draw():
	if not stats:
		draw_circle(Vector2.ZERO, 5, Color.WHITE)
		return

	# Main body
	draw_circle(Vector2.ZERO, stats.radius, stats.color)

	# Weapon indicators for visual feedback
	if stats.show_weapon_indicators:
		match stats.shooting_type:
			EnemyStats.ShootingType.NONE:
				# No weapons
				pass
			EnemyStats.ShootingType.SINGLE_SHOT:
				# Single barrel
				draw_line(Vector2.ZERO, Vector2(-8, 0), Color.YELLOW, 1.5)
			EnemyStats.ShootingType.BURST:
				# Multiple barrels
				for i in range(stats.burst_count):
					var angle = deg_to_rad(-stats.burst_spread/2 + (i * stats.burst_spread/(stats.burst_count-1)))
					var tip = Vector2(-8, 0).rotated(angle)
					draw_line(Vector2.ZERO, tip, Color.ORANGE, 1)

func _enable_debug_mode():
	# Fallback if no stats assigned
	stats = EnemyStats.new()
	stats.color = Color.WHITE
	stats.radius = 5
	print("Warning: Enemy has no stats assigned - using defaults")
