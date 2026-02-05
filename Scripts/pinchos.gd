extends CharacterBody2D


func _on_zona_muerte_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		if body.has_method("recibir_dano"):
			body.recibir_dano()
