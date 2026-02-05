extends  Node
# Variables para controlar el estado de la música
var musica_actual: AudioStreamPlayer

func _ready():
	# Iniciamos con la música 1 como la actual
	musica_actual = $Musica1
	$Musica1.volume_db = 0
	$Musica2.volume_db = -80 # Totalmente en silencio

func cambiar_musica(nodo_nuevo: AudioStreamPlayer, duracion: float = 2.0):
	# Si la música que queremos poner ya es la que suena, no hacemos nada
	if nodo_nuevo == musica_actual:
		return
		
	var nodo_viejo = musica_actual
	musica_actual = nodo_nuevo
	
	# Aseguramos que la nueva música empiece a sonar (aunque esté en silencio)
	nodo_nuevo.play()
	
	# Creamos el Tween para el cambio suave
	var tween = create_tween().set_parallel(true)
	
	# Bajamos el volumen de la vieja a -80 (silencio)
	tween.tween_property(nodo_viejo, "volume_db", -80, duracion).set_trans(Tween.TRANS_SINE)
	
	# Subimos el volumen de la nueva a 0 (normal)
	tween.tween_property(nodo_nuevo, "volume_db", 0, duracion).set_trans(Tween.TRANS_SINE)
	
	# Al terminar la transición, detenemos la música vieja para ahorrar recursos
	await tween.finished
	nodo_viejo.stop()
