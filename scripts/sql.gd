extends Control

var database : SQLite
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	database = SQLite.new()
	database.path = "res://ranking.bd"
	database.open_db()
 # Replace with function body.

func crear_tablas():
	database.query("
	CREATE TABLE IF NOT EXISTS ranking (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nombre TEXT,
	score INTEGER
		);
	")

func insertar_score(nombre, score):
	database.query("
    INSERT INTO ranking(nombre, score)
    VALUES('%s', %d);
	" % [nombre, score])

func obtener_top_10():
	database.query("
    SELECT nombre, score
    FROM ranking
    ORDER BY score DESC
    LIMIT 10;
	")
	return database.query_result

func insertar_datos_prueba():
	database.query("
    INSERT INTO ranking(nombre, score)
    VALUES
    ('fredy', 1000),
	('Anton', 1500),
	('tuki', 2000)
	")
