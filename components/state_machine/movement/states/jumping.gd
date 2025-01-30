class_name JumpingState
extends MovementState

func enter(previous_state_path: String, data := {}) -> void:
	print_state("jumping")
	player.jumps_made_counter += 1
	player.velocity.y = -player.jump_strength
	if data.has("velocity_x"):
		player.velocity.x += data.velocity_x
	#player.animation_player.play("jump")


func physics_update(delta: float) -> void:
	move_to_sides()
	calculate_gravity()

	player.move_and_slide()
	
	if player.wall_detector.is_colliding() and player.horizontal_direction != 0.0:
		finished.emit(WALL_SLIDING)
	
	if Input.is_action_just_released("jump"):
		if player.velocity.y < 0.0:
			player.velocity.y = lerpf(player.velocity.y, 0.0, player.jump_stop_multiplier)
		
	if player.velocity.y >= 0:
		finished.emit(FALLING)
