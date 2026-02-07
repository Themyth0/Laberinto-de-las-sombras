extends Area2D
@export_file("*.tscn") var siguiente_nivel

func _on_body_entered(body):
	if body.is_in_group("Jugador"):
		if Global.monedas >= 3:
			Global.reset_monedas()
			get_tree().change_scene_to_file(siguiente_nivel)
		else:
			var faltan = 3 - Global.monedas
			get_tree().call_group("interfaz", "mostrar_aviso", "Te faltan " + str(faltan) + " llaves")
