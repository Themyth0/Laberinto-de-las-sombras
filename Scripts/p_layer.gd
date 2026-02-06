extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var contenedor_corazones = $CanvasLayer/ContenedorCorazones
@onready var label_llaves = $CanvasLayer/LabelLlaves
@onready var audio_dolor = $AudioDolor
@onready var audio_saltar = $AudioSaltar
@onready var audio_caminar = $AudioCaminar

var vida = 2
var es_invulnerable = false

const SPEED = 150.0
const JUMP_VELOCITY = -450.0
const WALL_JUMP_VELOCITY = -400.0
const WALL_JUMP_PUSH = 300.0      

signal sumallave

func _ready():
	actualizar_interfaz()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		if is_on_wall() and velocity.y > 0:
			velocity += get_gravity() * delta * 0.5
		else:
			velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			reproducir_sonido_salto()
		elif is_on_wall():
			var wall_normal = get_wall_normal()
			velocity.y = WALL_JUMP_VELOCITY
			velocity.x = wall_normal.x * WALL_JUMP_PUSH
			animated_sprite_2d.flip_h = (velocity.x < 0)
			reproducir_sonido_salto()
	var direction := Input.get_axis("left", "right")
	
	if direction:
		if is_on_floor():
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, direction * SPEED, 15.0)
		
		if is_on_floor() or not is_on_wall():
			animated_sprite_2d.flip_h = (direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 10)

	move_and_slide()
	gestionar_sonidos_estado()
	actualizar_animaciones()
	actualizar_interfaz()


func reproducir_sonido_salto():
	audio_saltar.pitch_scale = randf_range(0.9, 1.1)
	audio_saltar.play()

func gestionar_sonidos_estado():
	if is_on_floor() and abs(velocity.x) > 0.1:
		if not audio_caminar.playing:
			audio_caminar.play()
	else:
		if audio_caminar.playing:
			audio_caminar.stop()

func actualizar_animaciones():
	if not is_on_floor():
		animated_sprite_2d.animation = "Saltar"
	elif abs(velocity.x) > 0.1:
		animated_sprite_2d.animation = "Correr"
	else:
		animated_sprite_2d.animation = "Parado"
func recibir_dano():
	if es_invulnerable:
		return
	
	audio_dolor.pitch_scale = randf_range(0.9, 1.1)
	audio_dolor.play()
	
	vida -= 1
	actualizar_interfaz()
	
	if vida <= 0:
		Global.monedas = 0 
		
		if audio_dolor.playing:
			await audio_dolor.finished 
		get_tree().reload_current_scene()
	else:
		activar_invulnerabilidad()

func activar_invulnerabilidad():
	es_invulnerable = true
	modulate.a = 0.5 
	await get_tree().create_timer(1.0).timeout
	modulate.a = 1.0
	es_invulnerable = false

func actualizar_interfaz():
	if contenedor_corazones:
		var corazones = contenedor_corazones.get_children()
		for i in range(corazones.size()):
			if i < vida:
				corazones[i].modulate.a = 1.0
			else:
				corazones[i].modulate.a = 0.3
	if label_llaves:
		label_llaves.text = "Llaves: " + str(Global.monedas)
