class_name RunningState
extends MovementState


func enter(previous_state_path: String, data := {}) -> void:
	print("running")
	player.jumps_made_counter = 0
	#player.animation_player.play("run")

func physics_update(delta: float) -> void:
	move_to_sides()

	player.move_and_slide()

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
	elif roundf(player.velocity.x) == 0.0:
		finished.emit(IDLE)
