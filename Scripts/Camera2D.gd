extends Camera2D
var vida: int
export var tela_de_morte = false
func _process(delta):
	vida = get_tree().get_nodes_in_group("Player")[0].vida
	$life.text = str(vida)
	$lifeBar.value = vida
	if vida == 0:
		tela_de_morte = true
	if tela_de_morte:
		$fundoEscuro.visible = true
		$emorreu.visible = true
		$TextureButton.visible = true
		$TextureButton.disabled = false
	else:
		$fundoEscuro.visible = false
		$emorreu.visible = false
		$TextureButton.visible = false
		$TextureButton.disabled = true
func _on_KinematicBody2D_apareci(pos):
	$".".position.x = pos.x
	$".".position.y = pos.y
	pass # Replace with function body.


func _on_KinematicBody2D_baixo():
	$".".position.y += 608

	pass # Replace with function body.


func _on_KinematicBody2D_cima():
	$".".position.y -= 608

	pass # Replace with function body.


func _on_KinematicBody2D_direita():
	position.x += 800

	pass # Replace with function body.


func _on_KinematicBody2D_esquerda():
	$".".position.x -= 800

	pass # Replace with function body.


func _on_Node2D_map(mapa):
	$Label.text = ""
	for y in range(0, len(mapa)):
		$Label.text += str(mapa[y]) + "\n"
	pass # Replace with function body.


func _on_Node2D_desci(andar):
	$andar.text = str(andar)
	pass # Replace with function body.
