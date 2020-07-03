extends Area2D

signal desceu

func _ready():

	pass 

signal pos(pos)

func _input(event):
	if event.is_action_pressed("test"):
		print("portal: ",position)
func Coletar_posicao_do_tile(x, y, tile, scale):
	var rex = (tile.x*x)*scale.x
	var rey = (tile.y*y)*scale.y
	return Vector2(rex,rey)
	pass
func _process(delta):
	emit_signal('pos',position)
	pass
	
func _on_Node2D_saida(pos):
	print(pos)

	position = pos

func _on_portal_body_entered(body):
	if body.name == "Player":
		emit_signal("desceu")
	pass


func _on_Node2D_map(mapa):
	for y in range(0, len(mapa)-1):
		for x in range(0, len(mapa[y])-1):
			if mapa[y][x] == "O":
				var posMeio = Coletar_posicao_do_tile(x+0.5,y+0.5,Vector2(800,608),Vector2(1,1))
				_on_Node2D_saida(posMeio)
	pass # Replace with function body.
