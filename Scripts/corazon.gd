extends Area2D
@onready var audio_corazon = $AudioCorazon

func _on_body_entered(body):

	if body.has_method("curar_vida"):
		var se_curo = body.curar_vida()
		if se_curo:
			visible = false
			$CollisionShape2D.set_deferred("disabled", true)
			if audio_corazon:
				audio_corazon.play()
				await audio_corazon.finished
			queue_free()
