extends CharacterBody2D

signal health_depleted

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DAMAGE_TAKEN_RATE = 10.0

var health = 100.0
var disabled = false

func _physics_process(delta: float) -> void:
	
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED

	if !disabled:
		move_and_slide()
	
	if velocity.length() > 0.0:
		%PlayerBody.play_walk_animation()
	else:
		%PlayerBody.play_idle_animation()
	
	var overlapping_mobs_count = %HurtBox.get_overlapping_bodies().size()
	if overlapping_mobs_count > 0:
		take_damage(overlapping_mobs_count, delta)


func take_damage(count: float, delta: float) -> void:
	if !%PlayerDamageSound.playing && !disabled:
		%PlayerDamageSound.pitch_scale = randf_range(1.0, 2.0)
		%PlayerDamageSound.play()
	
	health -= DAMAGE_TAKEN_RATE * count * delta
	%HealthBar.value = health
	
	if health <= 0.0:
		disabled = true
		health_depleted.emit()
