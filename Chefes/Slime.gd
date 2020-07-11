

extends KinematicBody2D
export var speed = 200
export(Vector2) var posicion
var vida = 50
signal morreu 
var velocity =  Vector2(1,1)
var gosmaPath = preload("res://Chefes/gosma.tscn")
var rastro = false
var rng = RandomNumberGenerator.new()

func _init():
	pass
func _ready():
	print("sou eu")
	rastro = true
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	velocity = move_and_slide(velocity)
	get_parent().get_child(4).position = position
	if vida < 1:
		emit_signal("morreu")
		queue_free()
	pass


func _on_baixo_body_entered(body):
	if body.name != "slime" and "Room" in body.name and body.name != "Porta":
		velocity.y *= -1
		velocity = velocity.normalized() * speed
	pass # Replace with function body.


func _on_cima_body_entered(body):
	if body.name != "slime" and "Room" in body.name and body.name != "Porta":
		velocity.y *= -1
		velocity = velocity.normalized() * speed


func _on_direita_body_entered(body):
	if body.name != "slime" and "Room" in body.name and body.name != "Porta":
		velocity.x *= -1
		velocity = velocity.normalized() * speed



func _on_esquerda_body_entered(body):
	if body.name != "slime" and "Room" in body.name and body.name != "Porta":
		
		velocity.x *= -1
		velocity = velocity.normalized() * speed

	pass # Replace with function body.


func _on_RastroTimer_timeout():
	if rastro == true:
		spawn_rastro()
	pass # Replace with function body.

func spawn_rastro():
	var newRastro = gosmaPath.instance()
	newRastro.position = position
	yield(get_tree().create_timer(0.05), "timeout")
	newRastro.slime = position
	newRastro.z_index = -1
	get_parent().add_child(newRastro)
	pass
