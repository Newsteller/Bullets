class_name WallSlidingState
extends MovementState


func enter(previous_state_path: String, data := {}) -> void:
	print("wall sliding")
	#player.animation_player.play("wall_sliding")

func physics_update(delta: float) -> void:
	pass
