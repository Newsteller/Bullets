class_name IdleState
extends MovementState

func enter(previous_state_path: String, data := {}) -> void:
	print_state("idling")
	player.velocity.x = 0.0
	player.jumps_made_counter = 0
	#player.animation_player.play("idle")

func physics_update(delta: float) -> void:
	calculate_gravity()
	player.move_and_slide()

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		finished.emit(RUNNING)
