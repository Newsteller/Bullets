extends Node2D

const MOB = preload("res://characters/enemies/slime/slime.tscn")
var isGameOverSoundPlaying = false

func spawn_mob() -> void:
	var new_mob = MOB.instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)


func _on_timer_timeout() -> void:
#	Checking if game over occured
	if !isGameOverSoundPlaying:
		spawn_mob()


func _on_player_health_depleted() -> void:
	%GameOverScreen.visible = true

	if isGameOverSoundPlaying == false:
		%GameOverSound.play()
		isGameOverSoundPlaying = true
	
