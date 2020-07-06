

extends TileMap

export(int) var tipo
signal battle(room)

var rng = RandomNumberGenerator.new()

onready var aranhaPath = preload("res://inimigos/arainha.tscn")
onready var portPath = preload("res://rooms/porta.tscn")
onready var keyPath = preload("res://rooms/chave.tscn")
onready var lockPath = preload("res://rooms/porta_fechada.tscn")
var battle = false
var jaBatalhou = false
var chave = false

func _init():
	_process(1)
	get_child(0).connect("body_entered",self, "colidiu")
	
func _ready():
	print(name," ", tipo)
	if tipo == 3:
		print("portas trancadas")
		get_parent().connect("Open", self, "OpenDoor")
		create_locked()

func check_enemies():
	
	var enemies = get_tree().get_nodes_in_group("Enemies"+name)
	if len(enemies) == 0:
		
		var portas = get_tree().get_nodes_in_group("Ports"+name)	
		for porta in portas:
			
			porta.free()
		if tipo == 2:
			chave = true
		battle = false
	pass
	
func colidiu(body):
	if tipo == 1 or tipo == 2:
		if body.name == "Player":
			if not jaBatalhou:
				start_battle()
				jaBatalhou = true
		
		emit_signal("battle", name)

func _process(delta):
	if tipo == 1 or tipo == 2:
		if battle:
			check_enemies()
		if chave:
			spawn_chave()
			chave = false
	
func start_battle():
	Coletar_posicoes_possiveis()
	pass
func converter_posicao(tile):
	var x = position.x + (cell_size.x*(tile.x+0.5))*scale.x 
	var y = position.y + (cell_size.y*(tile.y+0.5))*scale.y
	return Vector2(x,y)
	
func spawn_chave():
	var chave = keyPath.instance()
	var tileList: Array
	for x in range(0,25):
		for y in range(0,19):
			var tile = get_cell(x,y)
			if tile == 1:
				tileList.append(Vector2(x,y))
	var posTileList: Array
	for tile in tileList:
		posTileList.append(converter_posicao(tile))
	rng.randomize()
	var posicao = posTileList[rng.randi_range(0,len(posTileList)-1)]
	chave.position = posicao
	chave.add_to_group("Key")
	get_tree().get_root().add_child(chave)
				
func Coletar_posicoes_possiveis():
	var tileList: Array
	var portList: Array
	for x in range(0,25):
		for y in range(0,19):
			var tile = get_cell(x,y)
			if tile == 1:
				tileList.append(Vector2(x,y))
			if tile == 4:
				portList.append(Vector2(x,y))
	
	var posTileList: Array
	for tile in tileList:
		posTileList.append(converter_posicao(tile))
	
	var posPortList: Array
	for port in portList:
		posPortList.append(converter_posicao(port))
	var enemyCount = 5
	
	yield(countdown(), "completed") # waiting for the countdown() function to complete
	battle = true
	for n in enemyCount:
		rng.randomize()
		var posicao = posTileList[rng.randi_range(0,len(posTileList)-1)]
		var aranha = aranhaPath.instance()
		aranha.position = posicao
		aranha.add_to_group("Enemies"+name)
		get_tree().get_root().add_child(aranha)
	for p in posPortList:
		var porta = portPath.instance()
		porta.z_index = 1
		porta.position = p
		porta.add_to_group("Ports"+name)
		get_tree().get_root().add_child(porta)

func countdown():
	yield(get_tree(), "idle_frame") # returns a GDScriptFunctionState object to _ready()
	yield(get_tree().create_timer(0.5), "timeout")

func OpenDoor():
	print("a porta abriu")
	var portas = get_tree().get_nodes_in_group("Lock"+name)
	for porta in portas:
		porta.free()
	pass
	
func create_locked():
	var lockList: Array
	for x in range(0,25):
		for y in range(0,19):
			var tile = get_cell(x,y)
			if tile == 4:
				lockList.append(Vector2(x,y))
	var posLockList: Array
	for port in lockList:
		posLockList.append(converter_posicao(port))
	for p in posLockList:
		var porta = lockPath.instance()
		porta.z_index = 1
		porta.position = p
		porta.add_to_group("Lock"+name)
		get_tree().get_root().call_deferred("add_child", porta)

