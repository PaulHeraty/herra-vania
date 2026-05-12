class_name PlayerStateTakeDamage extends PlayerState

@export var move_speed: float = 100.0
@export var invulnerable_duration: float = 0.5

var time: float = 0.0
var dir: float = 1.0
@onready var damage_area: DamageArea = %DamageArea
@onready var hurt_audio: AudioStreamPlayer2D = $"../../HurtAudio"


# what happens when the state is initialized
func init() -> void:
	damage_area.damage_taken.connect(_on_damage_taken)
	pass
	
# what happen when you enter this state
func enter() -> void:
	player.animation_player.play("take_damage")
	time = player.animation_player.current_animation_length
	damage_area.make_invulnerable(invulnerable_duration)
	hurt_audio.play()
	VisualEffects.camera_shake(2.0)
	pass
	
# what happens when you exit this state
func exit() -> void:
	pass
	
# what happens when an input is pressed?
func handle_inputs(_event: InputEvent) -> PlayerState:
	return null
	
# what happens during the process loop
func process(_delta: float) -> PlayerState:
	time -= _delta
	if time <= 0.0:
		return idle
	return null

# what happens during the physics loop	
func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = move_speed * dir
	return null

func _on_damage_taken(attack_area: AttackArea) -> void:
	player.change_state(self)
	if attack_area.global_position.x < player.global_position.x:
		dir = 1.0
	else:
		dir = -1.0
	pass
