extends HBoxContainer

@onready var label_pos = $Principal3/Label_pos
@onready var label_name = $Principal3/Label_name
@onready var label_score = $Principal3/Label_score

func _ready():

    label_pos.custom_minimum_size.y = 6
    label_name.custom_minimum_size.y = 6
    label_score.custom_minimum_size.y = 6


func set_data(posicion, nombre, score):

    label_pos.text = str(posicion)
    label_name.text = str(nombre)
    label_score.text = str(score)
