extends Node2D

var player
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	player.connect("upgrade", self , "upgrade")
	player.connect("action", self , "actions")
	player.connect("reset", self , "reset")
	print("estou pronto")

func upgrade(id):
	if id == 1:
		print("upgrade aranha")
		$Aranha.visible = true
		player.dano += 1

func actions(action):
	
	if action == "moving":
		for nodeIndex in range(0, get_child_count()):
			get_child(nodeIndex).animation = "go"

	if action == "stop":
		for nodeIndex in range(0, get_child_count()):
			get_child(nodeIndex).animation = "stop"
func reset():
	for i in get_child_count():
		get_child(i).visible = false
