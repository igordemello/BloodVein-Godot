extends CharacterBody2D

@export var max_speed: float
@export var acceleration: float
@export var friction: float

@export var dash_speed: float
@export var dash_duration: float
@export var dash_cooldown: float


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var last_direction: Vector2 = Vector2.DOWN

var is_dashing: bool = false
var dash_timer: float = 0.0
var cooldown_timer: float = 0.0

func _physics_process(delta: float) -> void:
	if cooldown_timer > 0.0:
		cooldown_timer -= delta
	
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0.0:
			_end_dash()
		move_and_slide()
		return
	
	var input_vector := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		last_direction = input_vector
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	if Input.is_action_just_pressed("dash") and cooldown_timer <= 0.0:
		_start_dash()
	
	move_and_slide()
	_update_animation(input_vector)

func _start_dash() -> void:
	is_dashing = true
	dash_timer = dash_duration
	cooldown_timer = dash_cooldown
	
	velocity = last_direction.normalized() * dash_speed
	
	_play_dash_animation()
	_dash_flash()

func _end_dash() -> void:
	is_dashing = false

func _play_dash_animation() -> void:
	var dir := last_direction
	var anim_name := ""
	
	if abs(dir.x) > abs(dir.y):
		anim_name = "dash_side"
		sprite.flip_h = dir.x < 0
	else:
		if dir.y < 0:
			anim_name = "dash_back"
		else:
			anim_name = "dash_front"

	sprite.play(anim_name)

func _dash_flash() -> void:
	sprite.modulate = Color.WHITE
	
	var tween := create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), dash_duration * 0.2)
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0), dash_duration * 0.4)
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), dash_duration * 0.4)

func _update_animation(input_vector: Vector2) -> void:
	if is_dashing:
		return
	
	var moving := input_vector != Vector2.ZERO
	var dir := last_direction
	var anim_name := ""
	
	if abs(dir.x) > abs(dir.y):
		anim_name = "run_side" if moving else "idle_side"
		sprite.flip_h = dir.x < 0
	else:
		if dir.y < 0:
			anim_name = "run_back" if moving else "idle_back"
		else:
			anim_name = "run_front" if moving else "idle_front"
	
	if sprite.animation != anim_name:
		sprite.play(anim_name)
