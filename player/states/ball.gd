class_name PlayerStateBall extends PlayerState

const MORPH_AUDIO = preload("uid://dwxrvg05q6upd")
const MORPH_OUT_AUDIO = preload("uid://c5bs8suk6yspy")
const JUMP_AUDIO = preload("uid://bcro5h16y85pc")
const LAND_AUDIO = preload("uid://4h6r56dcymuh")

@export var jump_velocity: float = 400.0

var on_floor: bool = true

@onready var ball_ray_down: RayCast2D = %BallRayDown
@onready var ball_ray_up: RayCast2D = %BallRayUp

# what happens when the state is initialized
func init() -> void:
	pass
	
# what happen when you enter this state
func enter() -> void:
	player.animation_player.play("ball")
	
	var shape: CapsuleShape2D = player.collision_stand.get_shape() as CapsuleShape2D
	shape.radius = 11.0
	shape.height = 22.0
	
	player.collision_stand.position.y = -11.0
	player.da_stand.position.y = -11.0
	
	player.velocity.y -= 100.0
	Audio.play_spatial_sound(MORPH_AUDIO, player.global_position)
	pass
	
# what happens when you exit this state
func exit() -> void:
	player.animation_player.speed_scale = 1
	
	var shape: CapsuleShape2D = player.collision_stand.get_shape() as CapsuleShape2D
	shape.radius = 8.0
	shape.height = 46.0
	
	player.collision_stand.position.y = -23.0
	player.da_stand.position.y = -23.0
	player.velocity.y -= 100.0
	Audio.play_spatial_sound(MORPH_OUT_AUDIO, player.global_position)
	pass
	
# what happens when an input is pressed?
func handle_inputs(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("action"):
		if can_stand():
			if player.is_on_floor():
				return idle
			else:
				return fall
	if _event.is_action_pressed("jump"):
		if player.is_on_floor():
			if Input.is_action_pressed("down"):
				player.one_way_platform_shape_cast.force_shapecast_update()
				if player.one_way_platform_shape_cast.is_colliding():
					player.position.y += 4
					return null
			player.velocity.y -= jump_velocity
			Audio.play_spatial_sound(JUMP_AUDIO, player.global_position)
			VisualEffects.jump_dust(player.global_position)
	return null
	
# what happens during the process loop
func process(_delta: float) -> PlayerState:
	if player.direction.x == 0:
		player.animation_player.speed_scale = 0
	else:
		player.animation_player.speed_scale = 1
	return null

# what happens during the physics loop	
func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	
	if on_floor:
		if not player.is_on_floor():
			on_floor = false
	else:
		if player.is_on_floor():
			on_floor = true
			Audio.play_spatial_sound(LAND_AUDIO, player.global_position)
			VisualEffects.land_dust(player.global_position)
	return next_state

func can_stand() -> bool:
	ball_ray_up.force_raycast_update()
	ball_ray_down.force_raycast_update()
	if ball_ray_down.is_colliding() and ball_ray_up.is_colliding():
		return false
	return true
