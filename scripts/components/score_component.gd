class_name ScoreComponent extends Node

signal score_awarded(points: int)

@export var points_value: int = 100

func award() -> void:
    score_awarded.emit(points_value)
