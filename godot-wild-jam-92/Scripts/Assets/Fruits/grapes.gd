class_name Grapes
extends Fruit

@onready var sprite : MeshInstance3D = $Grapes/Plane

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	
	# if it is targetted, highlight white
	if targeted:
		var material : StandardMaterial3D = sprite.get_active_material(0).duplicate()
		material.emission = Color.WHITE
		sprite.set_surface_override_material(0, material)
	else:
		var material : StandardMaterial3D = sprite.get_active_material(0).duplicate()
		material.emission = COLOR
		sprite.set_surface_override_material(0, material)
