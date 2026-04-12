class_name Cauldron
extends StaticBody3D

var color : Color = Color(1, 0, 0)
var color_mix_ratio = 0.6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_color()


func change_color(new_color : Color = Color(1,0,0)) -> void:
	color = new_color
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	$Cauldron/Cylinder.set_surface_override_material(0, material)


func _on_pot_insert_body_entered(body: Node3D) -> void:
	if (body.is_in_group("fruit")):
		# change color when fruit comes into contact 
		var new_color : Color = color.lerp(body.COLOR, 0.5)
		change_color(new_color)
		signals.fruit_collected.emit(body.SCORE)
		body.queue_free()
