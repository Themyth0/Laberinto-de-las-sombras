extends Area2D


@onready var audio_moneda = $Audiomoneda  
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		Global.monedas += 1
		
		if audio_moneda != null:
			print("Reproduciendo sonido de moneda...") 
			sprite.visible = false
			collision.set_deferred("disabled", true)
			
			audio_moneda.play()
			await audio_moneda.finished
			print("Sonido terminado.")
		
		queue_free()
