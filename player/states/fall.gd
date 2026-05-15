class_name PlayerStateFall extends PlayerState

@export var coyote_time: float = 0.125
@export var fall_gravity_multiplier: float = 1.165
@export var jump_buffer_time: float = 0.2

const LAND = preload("uid://4h6r56dcymuh")

var coyote_timer: float = 0.0
var buffer_timer: float = 0.0

# what happens when the state is initialized
func init() -> void:
	pass
	
# what happen when you enter this state
func enter() -> void:
	player.animation_player.play("jump")
	player.animation_player.pause()
	player.gravity_multiplier = fall_gravity_multiplier
	
	if player.jump_count == 0:
		player.jump_count = 1
	
	var prev: PlayerState = player.previous_state
	if prev == jump or prev == attack or prev == dash:
		coyote_timer = 0.0
	elif player.previous_state == crouch:
		coyote_timer = 0.0
		player.jump_count = 1
	else:
		coyote_timer = coyote_time
	pass
	
# what happens when you exit this state
func exit() -> void:
	player.gravity_multiplier = 1.0
	buffer_timer = 0
	pass
	
# what happens when an input is pressed?
func handle_inputs(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("dash") and player.can_dash():
		return dash
	if _event.is_action_pressed("attack"):
		if player.ground_slam and Input.is_action_pressed("down"):
			return ground_slam
		return attack
	if _event.is_action_pressed("jump"):
		if coyote_timer > 0.0:
			player.jump_count = 0
			return jump
		elif player.jump_count <= 1 and player.double_jump:
			return jump
		else:
			buffer_timer = jump_buffer_time
	return next_state
	
# what happens during the process loop
func process(_delta: float) -> PlayerState:
	set_jump_frame()
	coyote_timer -= _delta
	buffer_timer -= _delta
	return next_state

# what happens during the physics loop	
func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		VisualEffects.land_dust(player.global_position)
		Audio.play_spatial_sound(LAND, player.global_position)

		if buffer_timer > 0:
			player.jump_count = 0
			return jump
		return idle
	player.velocity.x = player.direction.x * player.move_speed
	return next_state

func set_jump_frame() -> void:
	var frame: float = remap(player.velocity.y, 0.0, player.max_fall_velocity, 0.5, 1.0)
	player.animation_player.seek(frame, true)
	pass
