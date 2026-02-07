extends CanvasLayer
@onready var texto_monedas = $ContadorTexto
@onready var musica_1 = $Musica1
@onready var musica_2 = $Musica2

var musica_actual: AudioStreamPlayer

func _ready():
	
	musica_actual = musica_1
	musica_1.volume_db = 0
	musica_1.play()
	musica_2.volume_db = -80
	musica_2.stop()
	musica_1.finished.connect(_on_musica_1_finished)

func _process(_delta):
	texto_monedas.text = "Llaves: " + str(Global.monedas) + " / 3"
	
	if Global.monedas >= 3:
		texto_monedas.modulate = Color.GREEN
	else:
		texto_monedas.modulate = Color.WHITE

func cambiar_a_musica_2():
	_hacer_crossfade(musica_1, musica_2)
func cambiar_a_musica_1():
	_hacer_crossfade(musica_2, musica_1)

func _hacer_crossfade(nodo_a_apagar: AudioStreamPlayer, nodo_a_encender: AudioStreamPlayer):
	if nodo_a_encender == musica_actual:
		return 
	musica_actual = nodo_a_encender
	nodo_a_encender.volume_db = -80
	nodo_a_encender.play()
	var tween = create_tween().set_parallel(true)
	tween.tween_property(nodo_a_apagar, "volume_db", -80, 2.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(nodo_a_encender, "volume_db", 0, 2.0).set_trans(Tween.TRANS_SINE)
	await tween.finished
	nodo_a_apagar.stop()

func _on_musica_1_finished():
	cambiar_a_musica_2()
func mostrar_aviso(mensaje):
	$MensajeAviso.text = mensaje
	await get_tree().create_timer(2.0).timeout
	$MensajeAviso.text = ""
