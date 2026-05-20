extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $Label
@onready var button: Button = $Button

func _physics_process(delta: float) -> void:
    if Input.is_action_just_pressed("pausa"):
        get_tree().paused = not get_tree().paused
        color_rect.visible = not color_rect.visible
        label.visible = not label.visible
        button.visible = not button.visible



func _on_button_pressed() -> void:
    get_tree().paused = false
    get_tree().change_scene_to_file(ScenePaths.MENUS.MAIN)
