extends TileMap

func get_collision():
	$Collisor.connect("body_entered",self, "colidiu")
	
func colidiu(body):
	print("entrou na ", name)

func _process(delta):
	print(name)
	get_collision()
	
func _ready():
	print("rodou")
func _init():
	print("rodou")
	
