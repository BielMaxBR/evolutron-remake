extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Vector2) var slime
export(int) var dano = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(slime)
	$Timer.start()
	pass # Replace with function body.

func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.


func _on_ataque_body_entered(body):
	if body.name == "Player":
		body.vida -= dano
		queue_free()
	pass # Replace with function body.
