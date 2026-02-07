extends CanvasLayer
@onready var texto_monedas = $ContadorTexto
@onready var musica_1 = $Musica1
@onready var musica_2 = $Musica2

func _process(_delta):
	$ContadorTexto.text = "Llaves: " + str(Global.monedas) + " / 3"

func mostrar_aviso(mensaje):
	if has_node("MensajeAviso"):
		$MensajeAviso.text = mensaje
		await get_tree().create_timer(2.0).timeout
		$MensajeAviso.text = ""
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/menu.tscn")
func _ready():
	if musica_1 and musica_2:
		musica_1.finished.connect(_on_musica_1_finished)
		musica_2.finished.connect(_on_musica_2_finished)
		musica_1.play()
func _on_musica_1_finished():
	musica_2.play()
func _on_musica_2_finished():
	musica_1.play()
