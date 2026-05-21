class_name Enemy extends Area2D

@export var stats: EnemyStats

@onready var shoot_timer: Timer = $ShootTimer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Components
@onready var movement_component: MovementComponent = %MovementComponent
@onready var shooting_component: ShootingComponent = %ShootingComponent
@onready var animation_component: AnimationComponent = %AnimationComponent
@onready var hurt_component: HurtComponent = %HurtComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var vfx_component: VfxComponent = %VfxComponent

var _wave_time: float = 0.0
var can_move := true

func _ready():
    if not stats:
        _enable_debug_mode()
        return

    _setup_visuals()
    _setup_collision()

    movement_component.speed = stats.speed
    health_component.max_health = stats.health
    health_component.current_health = stats.health
    health_component.died.connect(_on_died)
    health_component.damaged.connect(_on_damaged)

    area_entered.connect(_on_area_entered)

    # Setup shooting
    if stats.shooting_type != EnemyStats.ShootingType.NONE:
        shoot_timer.wait_time = stats.shoot_delay
        shoot_timer.timeout.connect(_on_shoot_timer_timeout)
        shoot_timer.start()

func get_team() -> Team.Type:
    return Team.Type.ENEMY

func take_damage(amount: int, _attacker: Node2D = null) -> void:
    health_component.take_damage(amount)

func _setup_visuals():
    if stats.sprite_frames:
        animation_component.animated_sprite.sprite_frames = stats.sprite_frames
        animation_component.animated_sprite.animation = stats.default_animation
        animation_component.animated_sprite.scale = stats.sprite_scale
        animation_component.animated_sprite.offset = stats.sprite_offset

        # Play animation if it has multiple frames and speed > 0
        var animation_speed := stats.sprite_frames.get_animation_speed(stats.default_animation)
        if animation_speed > 0:
            animation_component.animated_sprite.play()
        animation_component.animated_sprite.visible = true
    else:
        animation_component.animated_sprite.visible = false
        queue_redraw()

func _on_area_entered(area: Area2D):
    hurt_component.deal_damage(area)

func _setup_collision():
    # Priority 1: Use custom collision shape if provided
    if stats.collision_shape:
        collision_shape_2d.shape = stats.collision_shape
        collision_shape_2d.rotation = stats.collision_rotation
        return

    # Priority 2: Use manual collision radius from stats
    if stats.collision_radius > 0:
        var circle_shape = CircleShape2D.new()
        circle_shape.radius = stats.collision_radius
        collision_shape_2d.shape = circle_shape
        return

    # Priority 3: Calculate from sprite (fallback)
    if stats.sprite_frames:
        var first_frame = stats.sprite_frames.get_frame_texture(stats.default_animation, 0)
        if first_frame:
            var sprite_size = first_frame.get_size() * stats.sprite_scale
            var radius = min(sprite_size.x, sprite_size.y) * 0.4
            var circle_shape = CircleShape2D.new()
            circle_shape.radius = radius
            collision_shape_2d.shape = circle_shape
            return

    # Priority 4: Ultra fallback
    var circle_shape = CircleShape2D.new()
    circle_shape.radius = 12.0
    collision_shape_2d.shape = circle_shape

func _physics_process(delta: float):
    if not stats:
        return

    if not can_move:
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
        shooting_component.shoot(self, stats.bullet_spawn_offset)

func _on_died(attacker: Node2D):
    GameModeManager.on_enemy_killed(attacker, stats.points_awarded)
    #Add enemy killed
    var wave_manager = get_tree().get_first_node_in_group("wave_manager")
    if wave_manager:
        wave_manager.on_enemy_killed()

    shoot_timer.stop()

    collision_shape_2d.set_deferred("disabled", true)
    set_physics_process(false)

    await get_tree().create_timer(0.2).timeout
    queue_free()

func _on_damaged(_new_hp: int, _max_hp: int, _attacker: Node2D):
    vfx_component.flash()

func _draw():
    if not stats or stats.sprite_frames:
        return  # Don't draw if we have a sprite

    # Fallback drawing for debug
    draw_circle(Vector2.ZERO, stats.collision_radius, Color.RED)
    draw_circle(Vector2.ZERO, stats.collision_radius - 1, Color.DARK_RED)

func _enable_debug_mode():
    stats = EnemyStats.new()
    print("Warning: Enemy has no stats assigned - using defaults")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
    queue_free()
