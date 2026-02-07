extends CharacterBody2D
@onready var sprite= $AnimatedSprite2D
@export var velocidad_patrulla = 100.0
@export var punto_a: Marker2D
@export var punto_b: Marker2D

var objetivo_actual: Marker2D
var player = null
var persiguiendo = false

func _ready():
	objetivo_actual = punto_a

func _physics_process(_delta):
	if persiguiendo and player:
		perseguir_objetivo(player.global_position, 150.0)
		actualizar_orientacion(player.global_position) 
	else:
		patrullar()
		if objetivo_actual:
			actualizar_orientacion(objetivo_actual.global_position)
			
	move_and_slide()

func actualizar_orientacion(objetivo_pos: Vector2):
	if objetivo_pos.x < global_position.x:
		sprite.flip_h = true  
	else:
		sprite.flip_h = false 

func patrullar():
	
	if not punto_a or not punto_b: 
		return
	var distancia = global_position.distance_to(objetivo_actual.global_position)

	if distancia < 15.0:
		if objetivo_actual == punto_a:
			objetivo_actual = punto_b
		else:
			objetivo_actual = punto_a
			
	perseguir_objetivo(objetivo_actual.global_position, velocidad_patrulla)

func perseguir_objetivo(destino: Vector2, velocidad: float):
	var direccion = (destino - global_position).normalized()
	velocity = direccion * velocidad


func _on_area_2d_body_entered(body):
	if body.is_in_group("Jugador"):
		player = body
		persiguiendo = true

func _on_area_2d_body_exited(body):
	if body == player:
		persiguiendo = false
		player = null


func _on_zona_muerte_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		
		if body.has_method("recibir_dano"):
			body.recibir_dano()
