class_name Formation extends Node2D

signal member_died()  # Add this signal

@export var formation_stats: FormationStats

enum FormationShape {
    LINE_HORIZONTAL,
    LINE_VERTICAL,
    V_SHAPE,
    CIRCLE
}

# For backward compatibility, keep individual exports but they will be ignored if stats is set
# (optional: you can remove these and rely only on stats)

var members: Array[Enemy] = []
var leader: Enemy = null
var original_offsets: Array[Vector2] = []

func _ready():
    if not formation_stats:
        push_error("Formation has no FormationStats assigned")
        queue_free()
        return
    _spawn_formation()
    set_process(true)

func _spawn_formation():
    var positions = _calculate_positions()
    var stats = formation_stats

    for i in range(stats.member_count):
        var enemy: Enemy = stats.enemy_scene.instantiate()

        # Duplicate base stats and apply variance if needed
        var enemy_stats = stats.enemy_stats.duplicate()
        if stats.randomize_stats:
            _apply_variance(enemy_stats, i)

        enemy.stats = enemy_stats
        enemy.position = positions[i]
        enemy.can_move = false
        add_child(enemy)
        members.append(enemy)
        original_offsets.append(positions[i])

        enemy.health_component.died.connect(_on_member_died)

    leader = members[0] if members.size() > 0 else null
    _center_formation()

func _center_formation():
    if members.is_empty():
        return
    # Compute centroid of all enemy local positions
    var centroid := Vector2.ZERO
    for enemy in members:
        centroid += enemy.position
    centroid /= members.size()

    # Shift formation so that centroid becomes the new origin
    global_position += centroid
    for enemy in members:
        enemy.position -= centroid

func _apply_variance(enemy_stats: EnemyStats, index: int):
    var stats = formation_stats
    if stats.health_variance > 0:
        var variance = randf_range(1.0 - stats.health_variance, 1.0 + stats.health_variance)
        enemy_stats.health = max(1, int(enemy_stats.health * variance))
    if stats.speed_variance > 0:
        var variance = randf_range(1.0 - stats.speed_variance, 1.0 + stats.speed_variance)
        enemy_stats.speed = enemy_stats.speed * variance
    # You can add more variance properties as needed

func _calculate_positions() -> Array[Vector2]:
    var stats = formation_stats
    var positions: Array[Vector2] = []
    var spacing = stats.spacing
    var count = stats.member_count

    match stats.formation_shape:
        FormationShape.LINE_HORIZONTAL:
            for i in range(count):
                positions.append(Vector2(i * spacing, 0))
        FormationShape.LINE_VERTICAL:
            for i in range(count):
                positions.append(Vector2(0, i * spacing))
        FormationShape.V_SHAPE:
            for i in range(count):
                var x = i * spacing
                var y = abs(i - count/2.0) * spacing * 0.5
                positions.append(Vector2(x, y))
        FormationShape.CIRCLE:
            var radius = spacing * count / 3.14159
            for i in range(count):
                var angle = (float(i) / count) * TAU
                var x = cos(angle) * radius
                var y = sin(angle) * radius
                positions.append(Vector2(x, y))
    return positions

func _process(delta):
    global_position += formation_stats.move_direction * formation_stats.move_speed * delta
    if formation_stats.rotation_speed != 0:
        rotation += deg_to_rad(formation_stats.rotation_speed) * delta

        for enemy in members:
            if is_instance_valid(enemy):
                enemy.rotation = -rotation

func _on_member_died():
    member_died.emit()

    members = members.filter(func(m): return is_instance_valid(m) and not m.is_queued_for_deletion())
    if members.is_empty():
        queue_free()
    elif leader != null and not is_instance_valid(leader):
        _on_leader_died()

func _on_leader_died():
    for enemy in members:
        enemy.get_parent().remove_child(enemy)
        get_parent().add_child(enemy)
        enemy.can_move = true
        enemy.movement_component.direction = Vector2.LEFT
    queue_free()
