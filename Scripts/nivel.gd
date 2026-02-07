extends  Node
var musica_actual: AudioStreamPlayer
func _ready():
	musica_actual = $Musica1
	$Musica1.volume_db = 0
	$Musica2.volume_db = -80 
func cambiar_musica(nodo_nuevo: AudioStreamPlayer, duracion: float = 2.0):
	if nodo_nuevo == musica_actual:
		return
	var nodo_viejo = musica_actual
	musica_actual = nodo_nuevo
	nodo_nuevo.play()
	var tween = create_tween().set_parallel(true)
	tween.tween_property(nodo_viejo, "volume_db", -80, duracion).set_trans(Tween.TRANS_SINE)
	tween.tween_property(nodo_nuevo, "volume_db", 0, duracion).set_trans(Tween.TRANS_SINE)
	await tween.finished
	nodo_viejo.stop()
