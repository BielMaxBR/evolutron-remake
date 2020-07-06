extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal vivo
# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.

func _process(delta):

	for i in range(1,9):
		var ray = "RayCast2D_"+str(i)
		if get_node(ray):
			if get_node(ray).is_colliding():
				$AnimatedSprite.animation = "andando"
				move_and_slide(Vector2(0,150))
			else:
				$AnimatedSprite.animation = 'parado'
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	if area.name == "Normal":
		queue_free()
	pass # Replace with function body.
