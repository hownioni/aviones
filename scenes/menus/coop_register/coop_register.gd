extends Control

@onready var name_input_1: LineEdit = %NameInput1
@onready var name_input_2: LineEdit = %NameInput2
@onready var mode_label: Label = %ModeLabel
@onready var continue_btn: Button = %Continuar

var _pending_mode: GameModeManager.Mode

func _ready():
    _pending_mode = GameModeManager.current_mode

    if _pending_mode == GameModeManager.Mode.COOP:
        mode_label.text = "Co-op Mode - Work together!"
    else:
        mode_label.text = "Versus Mode - Compete for highest score!"

func _on_continuar_pressed() -> void:
    var p1_name : String = name_input_1.text.strip_edges()
    var p2_name : String = name_input_2.text.strip_edges()

    if p1_name.is_empty() or p2_name.is_empty():
        print("Faltan nombres de jugadores")
        return

    # Reset scores first, then set names (reset_game() overwrites names with defaults)
    GameModeManager.reset_game()
    GameModeManager.set_player_name(0, p1_name)
    GameModeManager.set_player_name(1, p2_name)

    get_tree().change_scene_to_file(ScenePaths.PACKED.GAME_WORLD)


func _on_salir_pressed() -> void:
    get_tree().change_scene_to_file(ScenePaths.MENUS.MAIN)
