extends KinematicBody2D

var sim = true
var nao = true

export (int) var speed = 200
export(NodePath) var cam 
export(NodePath) var aranha

onready var aranhaPath = preload("res://inimigos/arainha.tscn")

signal esquerda
signal direita
signal cima
signal baixo
signal action(acao)
signal apareci(pos)

var velocity = Vector2()

func get_input():
	
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		emit_signal("action", "moving")
		emit_signal("action", "flip_right")
		velocity.x += 1
		
	if Input.is_action_pressed('left'):
		emit_signal("action", "moving")
		emit_signal("action", "flip_left")
		velocity.x -= 1
		
	if Input.is_action_pressed('down'):
		emit_signal("action", "moving")
		velocity.y += 1
		
	if Input.is_action_pressed('up'):
		emit_signal("action", "moving")
		velocity.y -= 1

	velocity = velocity.normalized() * speed
	
func _input(event):
	
	if event.is_action_pressed("attack") and not $attack.playing:
		emit_signal("action","attack")
		#var aranha = aranhaPath.instance()
		#aranha.position = position
	#	get_tree().get_root().add_child(aranha)
		#aranha.connect("vivo", self, "_on_aranha_vivo")
		#$attack.playing = true
		#$attack/Sound.playing = true
		
	if event.is_action_pressed("test"):
		emit_signal("action", "swap1")
	if event.is_action_pressed("0"):
		emit_signal("action", "swap0")
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

func _process(delta):
	if sim:
		emit_signal("apareci",$".".position)
		sim = false
		
	get_input()
	get_camera()
	
	velocity = move_and_slide(velocity)
	$arma.look_at(get_global_mouse_position())
	$Sprite.look_at(get_global_mouse_position())
	
func _ready():
	pass
	
func _on_Node2D_spawn(pos):

	$".".position = pos
	
#	get_node(aranha).position = Vector2(pos.x,pos.y-100)
	pass # Replace with function body.


func _on_attack_animation_finished():
	#$attack.playing = false
	#$attack/Sound.playing = false
	pass # Replace with function body.


func _on_portal_pos(pos):
	$ponta.look_at(pos)
	pass # Replace with function body.
