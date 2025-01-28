class_name FallingState
extends MovementState


func enter(previous_state_path: String, data := {}) -> void:
	print("falling")
	player.fall_speed = player.max_fall_speed
	#player.animation_player.play("fall")

func physics_update(delta: float) -> void:
	move_to_sides()
	calculate_gravity()

	player.move_and_slide()
	
	if not player.coyote_time_started:
		player.coyote_time_started = true
		player.coyote_time_timer.start(player.jump_coyote_time)

	if not player.is_on_floor():
		if Input.is_action_just_pressed("jump") and player.coyote_time_timer.time_left > 0.0 and player.jumps_made_counter == 0:
			player.coyote_time_timer.stop()
			finished.emit(JUMPING)
	else:
		player.coyote_time_started = false
		player.coyote_time_timer.stop()
		if is_equal_approx(player.velocity.x, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)
