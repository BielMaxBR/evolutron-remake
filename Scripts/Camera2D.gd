extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



		
func _on_KinematicBody2D_apareci(pos):
	$".".position.x = pos.x
	$".".position.y = pos.y
	print("da cam ", position)
	pass # Replace with function body.


func _on_KinematicBody2D_baixo():
	$".".position.y += 608
	print("baixo")
	pass # Replace with function body.


func _on_KinematicBody2D_cima():
	$".".position.y -= 608
	print("cima")
	pass # Replace with function body.


func _on_KinematicBody2D_direita():
	position.x += 800
	print("direita")
	pass # Replace with function body.


func _on_KinematicBody2D_esquerda():
	$".".position.x -= 800
	print("esquerda")
	pass # Replace with function body.


func _on_Node2D_map(mapa):
	for y in range(0, len(mapa)):
		$Label.text += str(mapa[y]) + "\n"
	pass # Replace with function body.
