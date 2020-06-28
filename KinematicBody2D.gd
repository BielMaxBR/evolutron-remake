extends KinematicBody2D
var sim = true
var nao = true
export (int) var speed = 200
export(NodePath) var cam
signal esquerda
signal direita
signal cima
signal baixo
signal apareci(pos)
var velocity = Vector2()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1

	velocity = velocity.normalized() * speed
func _input(event):
	if event.is_action_pressed("attack"):
		$attack.playing = true
func get_camera():
	#print(cam)
	var node = get_node(cam)
	var campos = node.position
	if position.x >= campos.x+400:
		emit_signal("direita")
	if position.x <= campos.x-400:
		emit_signal("esquerda")
	if position.y >= campos.y+308:
		emit_signal("baixo")
	if position.y <= campos.y-308:
		emit_signal("cima")


func _physics_process(delta):
	if sim:
		emit_signal("apareci",$".".position)
		sim = false
	get_input()
	get_camera()
	velocity = move_and_slide(velocity)
	$attack.look_at(get_global_mouse_position())
	$Sprite.look_at(get_global_mouse_position())
func _ready():
	pass
func _on_Node2D_spawn(pos):
	print("do player ",pos)
	$".".position = pos
	pass # Replace with function body.





