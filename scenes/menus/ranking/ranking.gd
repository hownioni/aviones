extends Control

@onready var container = $TextRanking

var fila_scene = preload("res://scenes/menus/ranking/RankingRow.tscn")

func _ready():

	cargar_ranking()

func cargar_ranking():

	# Limpiar filas anteriores
	for child in container.get_children():
		child.queue_free()
	var resultados = sql.obtener_top_10()
	var posicion = 1

	for fila in resultados:

		var nueva_fila = fila_scene.instantiate()

		container.add_child(nueva_fila)

		nueva_fila.set_data(
			posicion,
			fila["nombre"],
			fila["score"]
		)

		posicion += 1

	# Rellenar vacíos
	while posicion <= 10:

		var nueva_fila = fila_scene.instantiate()

		container.add_child(nueva_fila)

		nueva_fila.set_data(posicion, "--", "--")

		posicion += 1


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main/menu.tscn")
