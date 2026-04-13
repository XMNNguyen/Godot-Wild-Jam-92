class_name GameOver
extends Node2D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
