extends Control

@onready var name_input_1: LineEdit = %NameInput1
@onready var name_input_2: LineEdit = %NameInput2

func _on_continuar_pressed() -> void:
    var p1_name : String = name_input_1.text.strip_edges()
    var p2_name : String = name_input_2.text.strip_edges()

    if p1_name.is_empty() or p2_name.is_empty():
        print("Faltan nombres de jugadores")
        return

    get_tree().change_scene_to_file(ScenePaths.PACKED.GAME_WORLD)


func _on_salir_pressed() -> void:
    get_tree().change_scene_to_file(ScenePaths.MENUS.MAIN)
