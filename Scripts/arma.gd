extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ataqueAtual = 0

# Called when the node enters the scene tree for the first time.
func _process(delta):
	if $Normal.frame == 3 or $Normal.frame == 4:
		$Normal/Normal/CollisionShape2D.disabled  = false
	else:
		$Normal/Normal/CollisionShape2D.disabled = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func ataque():
	if ataqueAtual == 0:
		print("atacou0")
		$Normal.playing = true
		#if $Normal/Sound:
		#	$Normal/Sound.playing = true
	
	if ataqueAtual == 1:
		print("atacou1")
		$Anormal.playing = true
		if $Anormal/Sound:
			$Anormal/Sound.playing = true
			
func _on_Player_action(acao):
	if acao == "attack":
		ataque()
	if acao == "swap1":
		print("troquei 0")
		ataqueAtual = 1
	if acao == "swap0":
		print("troquei 1")
		ataqueAtual = 0
	pass # Replace with function body.


func _on_Sound_finished():
	$Anormal/Sound.playing = false
	pass # Replace with function body.


func _on_Anormal_animation_finished():
	$Anormal.playing = false
	pass # Replace with function body.


func _on_Normal_animation_finished():
	$Normal.playing = false
	pass # Replace with function body.
