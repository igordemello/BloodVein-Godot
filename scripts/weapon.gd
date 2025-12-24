extends Node2D

@export var data: WeaponData

@onready var sprite := $AnimatedSprite2D
@onready var collision := $Area2D/CollisionShape2D


var atacando := false
var attack_time := 0.0
var cooldown_time := 0.0
var angle_variation := 0.0

func _ready():
	aplicar_weapon_data()
	sprite.rotation_degrees = data.start_angle

func aplicar_weapon_data():
	if data == null:
		return
	
	sprite.play(data.animacao)
	collision.shape = data.collision_shape

func _process(delta):
	_update_weapon()
	
	if cooldown_time > 0.0:
		cooldown_time -= delta
	
	if Input.is_action_just_pressed("attack1") \
	and !atacando \
	and cooldown_time <= 0.0:
		iniciar_ataque()
	
	if atacando:
		processar_ataque(delta)

func iniciar_ataque():
	atacando = true
	attack_time = 0.0
	cooldown_time = data.cooldown
	angle_variation = randf_range(-5.0, 5.0)
	sprite.rotation_degrees = data.start_angle + angle_variation

func processar_ataque(delta):
	attack_time += delta
	var t := attack_time / data.attack_duration
	var eased_t := ease(t, -2.0)
	
	if eased_t < 0.5:
		sprite.rotation_degrees = lerp(
			data.start_angle + angle_variation,
			data.mid_angle + angle_variation,
			eased_t / 0.5
		)
	else:
		sprite.rotation_degrees = lerp(
			data.mid_angle + angle_variation,
			data.end_angle + angle_variation,
			(eased_t - 0.5) / 0.5
		)
	
	if eased_t >= 1.0:
		finalizar_ataque()
		

func finalizar_ataque():
	atacando = false
	angle_variation = 0.0
	sprite.rotation_degrees = data.start_angle

func _update_weapon() -> void:
	var mouse_pos := get_global_mouse_position()
	var dir := (mouse_pos - global_position).normalized()

	rotation = dir.angle()

	if dir.y < 0:
		z_index = 0
	else:
		z_index = 2
