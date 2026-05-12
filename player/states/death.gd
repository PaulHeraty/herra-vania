class_name PlayerStateDeath extends PlayerState

const DEATH_AUDIO = preload("uid://cgp3iq5unpayp")
	
# what happen when you enter this state
func enter() -> void:
	player.animation_player.play("death")
	Audio.play_spatial_sound(DEATH_AUDIO, player.global_position)
	Audio.play_music(null)
	await player.animation_player.animation_finished
	PlayerHud.show_game_over()
	pass
	
# what happens when you exit this state
func exit() -> void:
	pass
	
# what happens when an input is pressed?
func handle_inputs(_event: InputEvent) -> PlayerState:
	return null
	
# what happens during the process loop
func process(_delta: float) -> PlayerState:
	return null

# what happens during the physics loop	
func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = 0
	return null
