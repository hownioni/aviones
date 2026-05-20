extends Control

@onready var player1_label: LineEdit = $name_1
@onready var player2_label: LineEdit = $name_2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continuar_pressed() -> void:
	var p1 = player1_label.text.strip_edges()
	var p2 = player2_label.text.strip_edges()

	if p1 == "" or p2 == "":
		print("Faltan nombres de jugadores")
		return

	get_tree().change_scene_to_file("res://scenes/coop/fondo_coop.tscn")


func _on_salir_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main/menu.tscn")
