extends KinematicBody2D

export (int) var speed = 200

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

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)


func _on_Node2D_spawn(pos):
	print("do player ",pos)
	$".".position = pos
	pass # Replace with function body.


func _on_Node2D_map(mapa):
	for y in range(0, len(mapa)):
		$Label.text += str(mapa[y]) + "\n"

