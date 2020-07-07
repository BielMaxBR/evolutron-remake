extends KinematicBody2D

signal vivo
var avistado = false
export var vida = 3
var itemPath = preload("res://Items/Item.tscn")
export (int) var speed = 150
var areaDeAtaque = false
var target = Vector2()
var velocity = Vector2()
var player
var rng = RandomNumberGenerator.new()
func _ready():
	pass 

func check_life():
	if vida < 1:
		drop()
		queue_free()
	pass
func drop():
	rng.randomize()
	var sera = rng.randi_range(0,3)
	if sera == 0:
		var item = itemPath.instance()
		item.position = position
		item.id = 1
		get_tree().get_root().add_child(item)
func _process(delta):
	check_life()
	if areaDeAtaque:
		$Attack.look_at(player.position)
	target = get_tree().get_nodes_in_group("Player")
	target = target[0].position
	if avistado:
		if position.distance_to(target) > 32:
			velocity = move_and_slide(velocity)
		pass
	velocity = position.direction_to(target) * speed
	pass

func _on_Visao_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.name == "Player":
		print("avistado")
		avistado = true
		pass 


func _on_Visao_body_shape_exited(body_id, body, body_shape, area_shape):
		if body != null:
			if body.name == "Player":
				avistado = false
				pass 


func _on_Area_de_dano_area_entered(area):
	if area.name == "Normal":
		vida -= area.dano
		pass


func _on_attackTimer_timeout():
	if areaDeAtaque:
		$Attack.animation = "attack"

	pass # Replace with function body.


func _on_Area_de_ataque_body_entered(body):
	if body.name == "Player":
		areaDeAtaque = true
		player = body
	pass # Replace with function body.


func _on_Area_de_ataque_body_exited(body):
	if body.name == "Player":
		areaDeAtaque = false
	pass # Replace with function body.
