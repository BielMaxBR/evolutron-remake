extends Node2D

export(int, 0, 100) var numero_de_salas = 6
export(Vector2) var area = Vector2(6,6)
var parede = Color("#914400")*255
var chao = Color("#48ff00")*255
var porta = Color("#ffee00")*255
var muro = Color("#006d0f")*255
var spike = Color("#000000")*255
var rng = RandomNumberGenerator.new()

signal spawn(pos)
signal map(mapa)

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
			print("sala gerada ", x_atual, " ", y_atual, "\n")
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
	#print(tuc, "\n", toc)
	return toc

func nova_sala(salas, area):
	#print("salas atuais ", salas)
	rng.randomize()
	var sala_escolhida = salas[rng.randi_range(0, len(salas)-1)]
	if sala_escolhida == null:
		nova_sala(salas, area)
	var cima = [sala_escolhida[0], sala_escolhida[1]-1]
	var baixo = [sala_escolhida[0], sala_escolhida[1]+1]
	var esquerda = [sala_escolhida[0]-1, sala_escolhida[1]]
	var direita = [sala_escolhida[0]+1, sala_escolhida[1]]
	
	var salas_possiveis = []
	#print("escolhida ", sala_escolhida)
	var cimaX = int(cima[0])
	var cimaY = int(cima[1])
	if cima[1] >= 1 and se_tem(cima,salas) == false:
		salas_possiveis.append([cimaX,cimaY])
	#	print(">>> cima ",cima, salas.find(Array([cimaX,cimaY])))
	var direitaX = int(direita[0])
	var direitaY = int(direita[1])
	if direita[0] <= 5 and se_tem(direita,salas) == false:
		salas_possiveis.append([direitaX,direitaY])
	#	print(">>> direita ",direita, salas.find(Array([direitaX,direitaY])))
	var baixoX = int(baixo[0])
	var baixoY = int(baixo[1])
	if baixo[1] <= 5 and se_tem(baixo,salas) == false:
		salas_possiveis.append([baixoX,baixoY])
	#	print(">>> baixo ",baixo, salas.find(Array([baixoX,baixoY])))
	var esquerdaX = int(esquerda[0])
	var esquerdaY = int(esquerda[1])
	if esquerda[0] >= 1 and se_tem(esquerda,salas) == false:
		salas_possiveis.append([esquerdaX,esquerdaY])
	#	print(">>> esquerda ",[esquerdaX,esquerdaY], salas.find(Array([esquerdaX,esquerdaY])))


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
	#			print("sala sorteada ",sala_sorteada)
	#			print("---")
	#			print(se_tem(sala_sorteada, salas))
				return sala_sorteada
			else:
	#			print(se_tem(sala_sorteada, salas))
				return nova_sala(salas, area)
	else:
		return nova_sala(salas, area)

func criar_salas(salas ,mapa):
	print(salas)
	for sala in salas:
		var salaX = int(sala[0])
		var salaY = int(sala[1])
		if mapa[salaY][salaX] == ".":
			if salas.find(sala) == 0:
				mapa[salaY][salaX] = "S"
			elif salas.find(sala) == 4:
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
	
	var mapa_vazio = gerar_mapa_aberto()
	#mapa_aberto[2][3] = "1"
	
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

func gerar_tilemap(pos, tile, imagem, portas, index):
	var newTileMap = TileMap.new()

	$".".add_child(newTileMap)
	newTileMap.name = "Room" + str(index)
	newTileMap.add_to_group("Rooms")
	newTileMap.position = pos
	newTileMap.scale = tile.transform.get_scale()
	newTileMap.cell_size = tile.cell_size
	newTileMap.tile_set = tile.tile_set
	newTileMap.z_index = -1

	
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
	newTileMap.set_owner(get_tree().get_edited_scene_root())

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
				print("do nó ", pos)
				var posMeio = Coletar_posicao_do_tile(x+0.5,y+0.5,bigMap.cell_size,bigMap.transform.get_scale())
				emit_signal("spawn", posMeio)
				gerar_tilemap(pos,tile,'spawn.png', portas, index)
				index += 1
			elif minimapa[y][x] == "E":
				rng.randomize()
				var sala = rng.randi_range(0,5)
				var pos = Coletar_posicao_do_tile(x,y,bigMap.cell_size,bigMap.transform.get_scale())
				gerar_tilemap(pos,tile,'/enemy/sala'+str(sala)+'.png', portas, index)
				index += 1
			elif minimapa[y][x] == "K":
				var chave = true
				rng.randomize()
				var sala = rng.randi_range(0,5)
				var pos = Coletar_posicao_do_tile(x,y,bigMap.cell_size,bigMap.transform.get_scale())
				gerar_tilemap(pos,tile,'/enemy/sala'+str(sala)+'.png',portas, index)
				index += 1
			elif minimapa[y][x] == "O":
				var pos = Coletar_posicao_do_tile(x,y,bigMap.cell_size,bigMap.transform.get_scale())
				gerar_tilemap(pos,tile,'exit.png',portas, index)
				index += 1

func _ready():
	var tilemap = get_node('BigMap')
	var tile = $TileMap
	gerar_andar(tilemap, tile)
	for i in range(0, get_child_count()):
		if "Room" in get_child(i).name:
			print(get_child(i).name)

