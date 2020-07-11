extends Node2D
export(Shape2D) var shape2d 
export(Script) var RoomScript
export(int, LAYERS_2D_PHYSICS) var layers
export(int, 0, 100) var numero_de_salas = 8
export(Vector2) var area = Vector2(6,6)
#export(NodePath) onready var SlimeBossPath  = preload("res://Chefes/Slime.tscn")
const parede = Color("#914400")*255
const chao = Color("#48ff00")*255
const porta = Color("#ffee00")*255
const muro = Color("#006d0f")*255
const spike = Color("#000000")*255
var rng = RandomNumberGenerator.new()
export var andar = 1
var fechada: bool
signal spawn(pos)
signal map(mapa)
signal saida(pos)
signal desci(andar)
signal Open
signal boss(andar, meio)
func gerar_mapa_aberto():
	return '0'

func gerar_salas():
	var salas = []
	for i in range(0, numero_de_salas):
		
		if (i == 0):
			rng.randomize()
			var x_atual = int(rng.randi_range(0, 5))
			rng.randomize()
			var y_atual = int(rng.randi_range(0, 5))
			salas.append([x_atual,y_atual])
		else:
			var nova_sala = nova_sala(salas,area)
			if nova_sala:
				salas.append(nova_sala)
			else:
				nova_sala = nova_sala(salas,area)
				salas.append(nova_sala)

			pass
	return salas

func se_tem(sala,salas):
	var tuc = salas
	var x
	var y
	var tum = sala
	if typeof(tum) == TYPE_VECTOR2:
		x = int(tum.x)
		y = int(tum.y)
	elif typeof(tum) == TYPE_ARRAY:
		x = int(tum[0])
		y = int(tum[1])
	var xy = [x,y]
	var toc = tuc.has(Array(xy))
	return toc

func nova_sala(salas, area):

	rng.randomize()
	var sala_escolhida = salas[rng.randi_range(0, len(salas)-1)]
	if sala_escolhida == null:
		nova_sala(salas, area)
	var cima = [sala_escolhida[0], sala_escolhida[1]-1]
	var baixo = [sala_escolhida[0], sala_escolhida[1]+1]
	var esquerda = [sala_escolhida[0]-1, sala_escolhida[1]]
	var direita = [sala_escolhida[0]+1, sala_escolhida[1]]
	var salas_possiveis = []
	var cimaX = int(cima[0])
	var cimaY = int(cima[1])
	if cima[1] >= 1 and se_tem(cima,salas) == false:
		salas_possiveis.append([cimaX,cimaY])
	var direitaX = int(direita[0])
	var direitaY = int(direita[1])
	if direita[0] <= 5 and se_tem(direita,salas) == false:
		salas_possiveis.append([direitaX,direitaY])
	var baixoX = int(baixo[0])
	var baixoY = int(baixo[1])
	if baixo[1] <= 5 and se_tem(baixo,salas) == false:
		salas_possiveis.append([baixoX,baixoY])
	var esquerdaX = int(esquerda[0])
	var esquerdaY = int(esquerda[1])
	if esquerda[0] >= 1 and se_tem(esquerda,salas) == false:
		salas_possiveis.append([esquerdaX,esquerdaY])
	if len(salas_possiveis) >= 1:

			rng.randomize()
			var index_sala_sorteada = rng.randi_range(0,len(salas_possiveis)-1)
			var sala_sorteada = salas_possiveis[int(index_sala_sorteada)]
	#		print(index_sala_sorteada, " ", sala_sorteada)
			var i = false
			for t in range(len(salas)-1):
				if [sala_sorteada[0],sala_sorteada[1]] == salas[t]:
					i = true
					
			if salas.has(Array([int(sala_sorteada[0]),int(sala_sorteada[1])])) == false and sala_sorteada != null:
				return sala_sorteada
			else:
				return nova_sala(salas, area)
	else:
		return nova_sala(salas, area)

func criar_salas(salas ,mapa):
	for sala in salas:
		var salaX = int(sala[0])
		var salaY = int(sala[1])
		if mapa[salaY][salaX] == ".":
			if salas.find(sala) == 0:
				mapa[salaY][salaX] = "S"
			elif salas.find(sala) == len(salas)-2:
				mapa[salaY][salaX] = "K"
			elif salas.find(sala) == len(salas)-1:
				mapa[salaY][salaX] = "O"
			else:
				mapa[salaY][salaX] = "E"

	return mapa

func criar_cena():
	var mapa = [
		[".",".",".",".",".","."],
		[".",".",".",".",".","."],
		[".",".",".",".",".","."],
		[".",".",".",".",".","."],
		[".",".",".",".",".","."],
		[".",".",".",".",".","."],
	]
	var salas = gerar_salas()
	
	mapa = criar_salas(salas, mapa)
	for i in mapa:
		print(i)
	return mapa

func Coletar_posicao_do_tile(x, y, tile, scale):
	var rex = (tile.x*x)*scale.x
	var rey = (tile.y*y)*scale.y
	return Vector2(rex,rey)
	pass
	
func criar_sala_collider(pos):
	var collider = Area2D.new()
	var shape = CollisionShape2D.new()
	shape.call_deferred("set", "shape", shape2d)
	collider.name = "Collisor"
	collider.add_child(shape)
	collider.z_index = 0
	collider.monitoring = true
	collider.monitorable = true
	collider.input_pickable = true
	collider.collision_layer = layers
	return collider
	pass
	
func gerar_tilemap(pos, tile, imagem, portas, index, type):
	var newTileMap = TileMap.new()
	var SalaCollider = criar_sala_collider(pos)
	SalaCollider.position = Vector2(200, 152)
	newTileMap.add_child(SalaCollider)
	newTileMap.call_deferred("set", "script", RoomScript)
	newTileMap.set_script(RoomScript)
	newTileMap.name = "Room" + str(index)
	newTileMap.add_to_group("Rooms")
	newTileMap.position = pos
	newTileMap.scale = tile.transform.get_scale()
	newTileMap.cell_size = tile.cell_size
	newTileMap.tile_set = tile.tile_set
	newTileMap.z_index = -1
	newTileMap.tipo = type
	##	newTileMap.SlimeBossPath = SlimeBossPath
	
	for x in range(0,25):
		for y in range(0,19):
			var cor = ler_cores_da_imagem(imagem,x,y)
			if cor == chao:
				var tileIndex = 1
				newTileMap.set_cell(x,y,tileIndex)
			elif cor == parede:
				var tileIndex = 0
				newTileMap.set_cell(x,y,tileIndex)
			elif cor == porta:
				if y == 0: 
					if x == 11 or x == 12 or x == 13:
						if portas[0]:
							var tileIndex = 4
							newTileMap.set_cell(x,y,tileIndex)
						else:
							var tileIndex = 0
							newTileMap.set_cell(x,y,tileIndex)
				elif x == 24: 
					if y == 8 or y == 9 or y == 10:
						if portas[1]:
							var tileIndex = 4
							newTileMap.set_cell(x,y,tileIndex)
						else:
							var tileIndex = 0
							newTileMap.set_cell(x,y,tileIndex)
				elif y == 18: 
					if x == 11 or x == 12 or x == 13:
						if portas[2]:
							var tileIndex = 4
							newTileMap.set_cell(x,y,tileIndex)
						else:
							var tileIndex = 0
							newTileMap.set_cell(x,y,tileIndex)
				elif x == 0: 
					if y == 8 or y == 9 or y == 10:
						if portas[3]:
							var tileIndex = 4
							newTileMap.set_cell(x,y,tileIndex)
						else:
							var tileIndex = 0
							newTileMap.set_cell(x,y,tileIndex)

			elif cor == muro:
				var tileIndex = 2
				newTileMap.set_cell(x,y,tileIndex)
			elif cor == spike:
				var tileIndex = 6
				newTileMap.set_cell(x,y,tileIndex)
	#add_child(newTileMap)
	call_deferred("add_child", newTileMap)
	var rooms = get_tree().get_nodes_in_group("Rooms")
	for room in rooms:
		if room.name == newTileMap.name:
			if not room.is_connected("battle", self, "battle_mode"):
				room.connect("battle", self, "battle_mode")

func gerar_dados_da_imagem(imagem):

	var caminho = str("res://rooms/"+imagem)
	var image_texture_resource = load(caminho)
	
	var image = image_texture_resource.get_data()
	
	return image

func ler_cores_da_imagem(img,x,y):
	var data = gerar_dados_da_imagem(img)
	data.lock()
	var color = data.get_pixel(x,y)
	return color*255

func se_tem_sala(mapa, sala_atual):
	var cima = false
	var direita = false
	var baixo = false
	var esquerda = false
	
	if sala_atual.y-1 >= 0 and  mapa[sala_atual.y-1][sala_atual.x] != ".":
		cima = true
	
	if sala_atual.x+1 <= 5 and mapa[sala_atual.y][sala_atual.x+1] != ".":
		direita = true
	
	if sala_atual.y+1 <= 5 and mapa[sala_atual.y+1][sala_atual.x] != ".":
		baixo = true
	
	if sala_atual.x-1 >= 0 and mapa[sala_atual.y][sala_atual.x-1] != ".":
		esquerda = true
		
		
	return [cima,direita,baixo,esquerda]
	
func gerar_andar(bigMap, tile):
	
	var index = 0
	var minimapa = criar_cena()
	
	emit_signal("map",minimapa)
	for y in range(0, len(minimapa)):
		
		for x in range(0, len(minimapa[y])):
			
			var portas = se_tem_sala(minimapa, Vector2(x,y))
			
			if minimapa[y][x] == "S":
				var pos = Coletar_posicao_do_tile(x,y,bigMap.cell_size,bigMap.transform.get_scale())
				var posMeio = Coletar_posicao_do_tile(x+0.5,y+0.5,bigMap.cell_size,bigMap.transform.get_scale())
				emit_signal("spawn", posMeio)
				gerar_tilemap(pos,tile,'spawn.png', portas, index, 0)
				index += 1
				
			elif minimapa[y][x] == "E":
				
				rng.randomize()
				var sala = rng.randi_range(0,5)
				var pos = Coletar_posicao_do_tile(x,y,bigMap.cell_size,bigMap.transform.get_scale())
				gerar_tilemap(pos,tile,'enemy/sala'+str(sala)+'.png', portas, index, 1)
				index += 1
				
			elif minimapa[y][x] == "K":
				rng.randomize()
				var sala = rng.randi_range(0,5)
				var pos = Coletar_posicao_do_tile(x,y,bigMap.cell_size,bigMap.transform.get_scale())
				gerar_tilemap(pos,tile,'enemy/sala'+str(sala)+'.png',portas, index, 2)
				index += 1
				
			elif minimapa[y][x] == "O": 
				var pos = Coletar_posicao_do_tile(x,y,bigMap.cell_size,bigMap.transform.get_scale())
				var posMeio = Coletar_posicao_do_tile(x+0.5,y+0.5,bigMap.cell_size,bigMap.transform.get_scale())
				print(andar != 3)
				if andar != 3 and andar != 6 and andar != 9:
					print("não é chefe")
					emit_signal("saida", posMeio)
					gerar_tilemap(pos,tile,'exit.png',portas, index, 3)
				else:
					print('HORA DO BOSS!')
					boss_room(andar,pos, posMeio, tile, portas, index)
				index += 1
func _ready():
	fechada = true
	rng.randomize()
	var tilemap = get_node('BigMap')
	var tile = $TileMap
	gerar_andar(tilemap, tile)
	emit_signal("desci", andar)
	
func _on_portal_desceu():
	var rooms = get_tree().get_nodes_in_group("Rooms")
	for room in rooms:
		room.free()
	andar += 1
	_ready()

func battle_mode(nome):
	pass

func _process(delta):
	find_boss()
	check_key()

func check_key():
	var key = get_tree().get_nodes_in_group("Key")
	if len(key) > 0:
		if not key[0].is_connected("colected", self, "keyColected"):
			key[0].connect("colected", self, "keyColected")
			fechada = true

func keyColected():
	emit_signal("Open")
	pass

func _on_TextureButton_button_down():
	reset()
	
func reset():
	$Player.dano = 0
	$Player.reset = true
	$Player.vida = 5
	$Camera2D.tela_de_morte = false
	keyColected()
	var rooms = get_tree().get_nodes_in_group("Rooms")
	for room in rooms:
		room.free()
	andar = 1
	_ready()
	pass

func _on_voltar_button_down():
	reset()
	inicio()
	pass 

func inicio():
	pass

func boss_room(andar, pos, meio, tile,portas,index):
	gerar_tilemap(pos,tile,'boss.png',portas, index, 4)
	yield(get_tree().create_timer(1),"timeout")
	emit_signal("boss", andar, meio)
	pass
	
func find_boss():
	pass
