class_name WallSlidingState
extends MovementState


func enter(previous_state_path: String, data := {}) -> void:
	print_state("wall sliding")
	player.fall_speed = player.wall_fall_speed
	#player.animation_player.play("wall_sliding")


func physics_update(delta: float) -> void:
	move_to_sides()
	calculate_gravity()

	player.move_and_slide()
	
	if Input.is_action_just_pressed("jump"):
		add_velocity(Vector2(player.horizontal_direction * -player.wall_jump_pushback, 0))
		finished.emit(JUMPING)

	if not player.wall_detector.is_colliding() or is_zero_approx(player.horizontal_direction):
		finished.emit(FALLING)
	
	if is_zero_approx(player.velocity.y):
		finished.emit(FALLING)


func exit() -> void:
	player.fall_speed = player.max_fall_speed
