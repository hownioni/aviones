class_name VfxComponent extends Node

@export var target: CanvasItem

## Flash the target with a color for a duration, then restore.
func flash(color: Color = Color.RED, duration: float = 0.1) -> void:
    var canvas_item = _get_target()
    if not canvas_item:
        return

    var original = canvas_item.modulate
    canvas_item.modulate = color

    var tween = create_tween()
    tween.tween_property(canvas_item, "modulate", original, duration)

## Shake the target's position (relative offset) with given intensity.
func shake(intensity: float = 5.0, duration: float = 0.2) -> void:
    var canvas_item = _get_target()
    if not canvas_item:
        return

    var original_pos = canvas_item.position
    var elapsed = 0.0
    while elapsed < duration:
        var offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
        canvas_item.position = original_pos + offset
        await get_tree().process_frame
        elapsed += get_process_delta_time()
    canvas_item.position = original_pos

## Simple scale pulse (grow and shrink).
func pulse_scale(from_scale: float = 1.0, to_scale: float = 1.2, duration: float = 0.1) -> void:
    var canvas_item = _get_target()
    if not canvas_item:
        return

    var original = canvas_item.scale
    var tween = create_tween()
    tween.tween_property(canvas_item, "scale", Vector2(to_scale, to_scale), duration * 0.5)
    tween.tween_property(canvas_item, "scale", Vector2(from_scale, from_scale), duration * 0.5)
    # Optionally await tween.finished
    await tween.finished

func _get_target() -> CanvasItem:
    if target:
        return target
    # Try to get the parent if it's a CanvasItem (Sprite2D, AnimatedSprite2D, etc.)
    var parent = get_parent()
    if parent is CanvasItem:
        return parent
    push_warning("VfxComponent: No valid target CanvasItem found.")
    return null
