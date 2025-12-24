extends Resource
class_name WeaponData

@export var nome: String
@export var animacao: String

@export var dano: int
@export var cooldown: float
@export var knockback: float

@export var attack_duration: float
@export var start_angle := 90.0
@export var mid_angle := 45.0
@export var end_angle := 135.0


@export var collision_shape: Shape2D
