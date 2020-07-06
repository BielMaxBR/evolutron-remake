extends Area2D

signal colected
func _on_Area2D_body_entered(body):
	if body.name == "Player":
		print("coletado")
		emit_signal("colected")
		queue_free()
	pass # Replace with function body.
