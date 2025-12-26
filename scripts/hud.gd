extends CanvasLayer

@export var player: CharacterBody2D

@onready var mana_bar: TextureProgressBar = $mana_bar
@onready var hp_bar: TextureProgressBar = $hp_bar
@onready var stamina_bar: TextureProgressBar = $stamina_bar


func _process(delta: float) -> void:
	mana_bar.value = player.mana
	hp_bar.value = player.life
	stamina_bar.value = player.stamina
