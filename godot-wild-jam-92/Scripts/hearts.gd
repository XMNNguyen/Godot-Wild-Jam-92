class_name Hearts
extends HBoxContainer


var heart : String = "res://Scenes/UI/heart.tscn"

@onready var ui = $"../.."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# fill the heart bar
	for i in range(ui.MAX_LIFE):
		var new_heart = load(heart).instantiate()
		add_child(new_heart)


func lose_health() -> void:
	get_children().remove_at(0)


func gain_health() -> void:
	var new_heart = load(heart).instantiate()
	add_child(new_heart)
