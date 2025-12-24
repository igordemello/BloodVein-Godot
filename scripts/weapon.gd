extends Node2D

@export var data: WeaponData

@onready var sprite := $AnimatedSprite2D
@onready var collision := $Area2D/CollisionShape2D

func _ready():
	aplicar_weapon_data()

func aplicar_weapon_data():
	if data == null:
		return
	
	sprite.play(data.animacao)
	collision.shape = data.collision_shape
