class_name Heart
extends TextureRect

@onready var sprite_tree = $AnimationTree
@onready var state_machine = sprite_tree["parameters/playback"]

func delete() -> void:
	state_machine.travel("hit")


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	if anim_name == "hit":
		queue_free()
