extends Area2D


@onready var audio_recoger = $AudioRecoger

func _on_body_entered(body):
	if body.is_in_group("Jugador"):
		
		Global.monedas += 1
		
		
		visible = false
		set_deferred("monitoring", false) 
		
		
		audio_recoger.play()
		
		
		await audio_recoger.finished
		
		
		queue_free()
