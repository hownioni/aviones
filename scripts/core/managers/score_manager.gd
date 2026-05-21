extends Node
## Centralized scoring system. Emits signals when score changes.

signal score_changed(new_score: int)
signal combo_changed(current_combo: int)
signal high_score_broken(new_high_score: int)

@export var starting_score: int = 0
@export var combo_decay_time: float = 2.0  # Seconds without kills to reset combo

var current_score: int = 0:
    set(value):
        current_score = value
        score_changed.emit(current_score)

        # Check for high score (optional, could be saved to file)
        if current_score > _high_score:
            _high_score = current_score
            high_score_broken.emit(_high_score)

var current_combo: int = 0:
    set(value):
        current_combo = value
        combo_changed.emit(current_combo)

        # Reset combo timer on any kill
        _reset_combo_timer()

var _high_score: int = 0
var _combo_timer: Timer

func _ready():
    current_score = starting_score
    _setup_combo_timer()

func _setup_combo_timer():
    _combo_timer = Timer.new()
    _combo_timer.wait_time = combo_decay_time
    _combo_timer.one_shot = true
    _combo_timer.timeout.connect(_reset_combo)
    add_child(_combo_timer)

func add_points(base_points: int) -> void:
    ## Add points with combo multiplier
    var multiplier = 1 + (current_combo * 0.1)  # 10% per combo level
    var total_points = int(base_points * multiplier)
    current_score += total_points
    current_combo += 1

func _reset_combo_timer():
    if _combo_timer:
        _combo_timer.start()

func _reset_combo():
    current_combo = 0

func reset_score():
    current_score = 0
    current_combo = 0
    _high_score = 0

func get_high_score() -> int:
    return _high_score
