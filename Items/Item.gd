extends Area2D

export(int) var id
export(Texture) var idum
#export(Texture) var idum
#export(Texture) var idum
#export(Texture) var idum
#export(Texture) var idum
func _ready():
	if id == 1:
		$Sprite.texture = idum
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
