extends KinematicBody2D

var morto = false
var spawn = true
export (int) var dano = 0
export (int) var vida = 5
export (int) var speed = 200
export (bool) var reset = false
export(NodePath) var cam 
export(NodePath) var aranha

onready var aranhaPath = preload("res://inimigos/arainha.tscn")

signal esquerda
signal direita
signal cima
signal baixo
signal reset
signal action(acao)
signal apareci(pos)
signal upgrade(id)
signal frame(anim,frame)
var andando = false
var velocity = Vector2()

func check_life():
	if vida < 1:
		print("morreu")
		visible = false
		morto = true

func get_input():
	if not morto:
		velocity = Vector2()
		if Input.is_action_pressed('right'):
			andando = true
			emit_signal("action", "moving")
			emit_signal("action", "flip_right")
			velocity.x += 1
			
		if Input.is_action_just_released("right"):
			andando = false
			emit_signal("action", "stop")
			
		if Input.is_action_pressed('left'):
			andando = true
			emit_signal("action", "moving")
			emit_signal("action", "flip_left")
			velocity.x -= 1
			
		if Input.is_action_just_released("left"):
			emit_signal("action", "stop")
			andando = false	
			
		if Input.is_action_pressed('down'):
			andando = true
			
			emit_signal("action", "moving")
			velocity.y += 1
		if Input.is_action_just_released("down"):
			emit_signal("action", "stop")
			andando = false
			
		if Input.is_action_pressed('up'):
			andando = true
			emit_signal("action", "moving")
			velocity.y -= 1
			
		if Input.is_action_just_released("up"):
			emit_signal("action", "stop")
			andando = false
			
		velocity = velocity.normalized() * speed
	
func _input(event):
	if not morto:
		if event.is_action_pressed("attack"):
			emit_signal("action","attack")
			
		if event.is_action_pressed("test"):
			if vida > 0:
				vida -= 1
			emit_signal("action", "swap1")

		if event.is_action_pressed("0"):
			emit_signal("action", "swap0")
			
		if event.is_action_pressed("scape"):
			position.y -= 50

func get_camera():
	#print(cam)
	var node = get_node(cam)
	var campos = node.position
	if andando:
		$Sprite.set_animation("Walk")
	else:
		$Sprite.set_animation("stop")
	if position.x >= campos.x+400:
		emit_signal("direita")
		
	if position.x <= campos.x-400:
		emit_signal("esquerda")
		
	if position.y >= campos.y+308:
		emit_signal("baixo")
		
	if position.y <= campos.y-308:
		emit_signal("cima")

func _process(delta):
	if spawn:
		emit_signal("apareci",$".".position)
		spawn = false
		
	get_input()
	get_camera()
	check_life()
	check_reset()
	velocity = move_and_slide(velocity)
	$arma.look_at(get_global_mouse_position())
	#$Sprite.look_at(get_global_mouse_position())
	
func check_reset():
	if reset:
		emit_signal("reset")
		morto = false
		visible = true
		reset = false
	pass
	
func _on_Node2D_spawn(pos):
	$".".position = pos


func _on_portal_pos(pos):
	$ponta.look_at(pos)
	pass # Replace with function body.


func _on_Player_action(acao):
	pass # Replace with function body.


func _on_Area_de_dano_area_entered(area):
	if area.name == "ataque":
		if area.get_groups()[0] == "Nocivo":
			vida -= area.dano
	if area.name == "Item":
		emit_signal("upgrade", area.id)
		print("coletado")
		area.queue_free()
	pass # Replace with function body.


func _on_Sprite_frame_changed():
	emit_signal("frame",$Sprite.animation, $Sprite.frame)
	pass # Replace with function body.
