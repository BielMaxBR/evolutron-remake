extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	
	check_frame()

func check_frame():
	if frame == 2 and animation == "attack":
		$ataque/CollisionShape2D.disabled = false
	else:
		$ataque/CollisionShape2D.disabled = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Attack_animation_finished():
	if animation == "attack":
		animation = "no"
	pass # Replace with function body.
