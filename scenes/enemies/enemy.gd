class_name Enemy extends Area2D

@export var stats: EnemyStats

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Components
@onready var movement_component: MovementComponent = %MovementComponent
@onready var shooting_component: ShootingComponent = %ShootingComponent

var _wave_time: float = 0.0

func _ready():
	if not stats:
		_enable_debug_mode()
		return

    _setup_visuals()
    _setup_collision()

    movement_component.speed = stats.speed

    # Setup shooting
    if stats.shooting_type != EnemyStats.ShootingType.NONE:
        shoot_timer.wait_time = stats.shoot_delay
        shoot_timer.timeout.connect(_on_shoot_timer_timeout)
        shoot_timer.start()

func _setup_visuals():
    if stats.sprite_frames:
        animated_sprite_2d.sprite_frames = stats.sprite_frames
        animated_sprite_2d.animation = stats.default_animation
        animated_sprite_2d.scale = stats.sprite_scale
        animated_sprite_2d.offset = stats.sprite_offset

        # Play animation if it has multiple frames and speed > 0
        var animation_speed := stats.sprite_frames.get_animation_speed(stats.default_animation)
        if animation_speed > 0:
            animated_sprite_2d.play()
        animated_sprite_2d.visible = true
    else:
        animated_sprite_2d.visible = false
        queue_redraw()

func _setup_collision():
    # If manual collision radius is set and not default, use it
    if stats.collision_radius > 0 and stats.collision_radius != 8.0:  # 8 is default
        var circle_shape = CircleShape2D.new()
        circle_shape.radius = stats.collision_radius
        collision_shape_2d.shape = circle_shape
        return

    # Otherwise try to calculate from sprite
    if stats.collision_shape:
        collision_shape_2d.shape = stats.collision_shape
        collision_shape_2d.rotation = stats.collision_rotation
    elif stats.sprite_frames:
        var first_frame = stats.sprite_frames.get_frame_texture(stats.default_animation, 0)
        if first_frame:
            var sprite_size = first_frame.get_size() * stats.sprite_scale
            var radius = min(sprite_size.x, sprite_size.y) * 0.5  # Half size
            var circle_shape = CircleShape2D.new()
            circle_shape.radius = radius
            collision_shape_2d.shape = circle_shape
    else:
        var circle_shape = CircleShape2D.new()
        circle_shape.radius = stats.collision_radius
        collision_shape_2d.shape = circle_shape

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
            wave_direction.y = sin(_wave_time * stats.wave_frequency)
            movement_component.direction = wave_direction

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
	shooting_component.shoot(self, stats.bullet_spawn_offset)

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
    if not stats or stats.sprite_frames:
        return  # Don't draw if we have a sprite

    # Fallback drawing for debug
    draw_circle(Vector2.ZERO, stats.collision_radius, Color.RED)
    draw_circle(Vector2.ZERO, stats.collision_radius - 1, Color.DARK_RED)

func _enable_debug_mode():
    stats = EnemyStats.new()
    print("Warning: Enemy has no stats assigned - using defaults")
