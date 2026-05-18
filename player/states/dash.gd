class_name PlayerStateDash extends PlayerState

const DASH_AUDIO = preload("uid://bfllw6qt0eofq")

@export var duration: float = 0.25
@export var speed: float = 300.0
@export var effect_delay: float = 0.05

var dir: float = 1.0
var time: float = 0.0
var effect_time: float = 0.0

@onready var damage_area: DamageArea = %DamageArea


# what happens when the state is initialized
func init() -> void:
	pass
	
# what happen when you enter this state
func enter() -> void:
	player.animation_player.play("dash")
	time = duration
	effect_time = 0.0
	get_dash_direction()
	
	damage_area.make_invulnerable(duration)
	Audio.play_spatial_sound(DASH_AUDIO, player.global_position)
	player.gravity_multiplier = 0.0
	player.velocity.y = 0.0
	player.dash_count += 1
	
	player.sprite.tween_color(duration)
	pass
	
# what happens when you exit this state
func exit() -> void:
	player.gravity_multiplier = 1.0
	pass
	
# what happens when an input is pressed?
func handle_inputs(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("action") and player.can_morph():
		return ball
	return null
	
# what happens during the process loop
func process(_delta: float) -> PlayerState:
	time -= _delta
	if time <= 0.0:
		if player.is_on_floor():
			return idle
		else:
			return fall
	
	effect_time -= _delta
	if effect_time < 0.0:
		effect_time = effect_delay
		player.sprite.ghost()
	return null

# what happens during the physics loop	
func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = (speed + speed * (time / duration)) * dir
	return null

func get_dash_direction() -> void:
	dir = 1.0
	if player.sprite.flip_h == true:
		dir = -1.0
	pass
