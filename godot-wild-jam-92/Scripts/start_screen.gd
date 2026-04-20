extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_controls_pressed() -> void:
    $ControlPanel.visible = true


func _on_start_pressed() -> void:
    get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_exit_pressed() -> void:
    get_tree().quit()


func _on_hide_pressed() -> void:
    $ControlPanel.visible = false
