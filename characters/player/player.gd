extends CharacterBody2D

signal health_depleted

const SPEED = 300.0
const JUMP_VELOCITY = 500.0
const DAMAGE_TAKEN_RATE = 25.0

var health = 100.0
var disabled = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if !disabled:
		move_and_slide()
	
	if velocity.length() > 0.0:
		%PlayerBody.play_walk_animation()
	else:
		%PlayerBody.play_idle_animation()
	
	var overlapping_mobs_count = %HurtBox.get_overlapping_bodies().size()
	if overlapping_mobs_count > 0:
		take_bullet_damage(overlapping_mobs_count, delta)


func take_bullet_damage(count: float, delta: float) -> void:
	if !%PlayerDamageSound.playing && !disabled:
		%PlayerDamageSound.pitch_scale = randf_range(1.0, 2.0)
		%PlayerDamageSound.play()
	
	health -= DAMAGE_TAKEN_RATE * count * delta
	%HealthBar.value = health
	
	if health <= 0.0:
		disabled = true
		health_depleted.emit()
