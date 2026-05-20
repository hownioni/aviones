extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Sql.crear_tablas()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass



func _on_solo_game_pressed() -> void:
    pass # Replace with function body.

func _on_duo_game_pressed() -> void:
    get_tree().change_scene_to_file("res://coop.tscn")

func _on_ranking_pressed() -> void:
    get_tree().change_scene_to_file(ScenePaths.MENUS.RANKING)

func _on_salir_pressed() -> void:
    get_tree().quit()
