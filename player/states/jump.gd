class_name PlayerStateJump extends PlayerState

@export var jump_velocity: float = 450.0
const JUMP = preload("uid://bcro5h16y85pc")

# what happens when the state is initialized
func init() -> void:
	pass
	
# what happen when you enter this state
func enter() -> void:
	if player.is_on_floor():
		VisualEffects.jump_dust(player.global_position)
	else:
		VisualEffects.hit_dust(player.global_position)
	player.animation_player.play("jump")
	player.animation_player.pause()
	
	do_jump()
	
	if player.previous_state == fall and not Input.is_action_pressed("jump"):
		await get_tree().physics_frame
		player.velocity.y *= 0.5
		player.change_state(fall)
		pass
	pass
	
# what happens when you exit this state
func exit() -> void:
	pass
	
# what happens when an input is pressed?
func handle_inputs(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("dash") and player.can_dash():
		return dash
	if _event.is_action_pressed("attack"):
		if player.ground_slam and Input.is_action_pressed("down"):
			return ground_slam
		return attack
	if _event.is_action_released("jump"):
		return fall
	return next_state
	
# what happens during the process loop
func process(_delta: float) -> PlayerState:
	set_jump_frame()
	return next_state

# what happens during the physics loop	
func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0.0:
		return fall
	player.velocity.x = player.direction.x * player.move_speed
	return next_state

func do_jump() -> void:
	if player.jump_count > 0:
		if player.double_jump == false:
			return
		elif player.jump_count > 1:
			return
	player.jump_count += 1
	player.velocity.y = -jump_velocity
	Audio.play_spatial_sound(JUMP, player.global_position)
	pass
	
func set_jump_frame() -> void:
	var frame: float = remap(player.velocity.y, -jump_velocity, 0.0, 0.0, 0.5)
	player.animation_player.seek(frame, true)
	pass
