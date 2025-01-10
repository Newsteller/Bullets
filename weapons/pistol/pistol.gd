extends Area2D

const BULLET = preload("res://weapons/pistol/pistol_bullet.tscn")

var disabled = false

func _physics_process(delta: float) -> void:
	look_at(%WeaponPivot.get_global_mouse_position())
	
	if Input.is_action_just_pressed("shoot"):
		shoot()


func shoot() -> void:
	if !disabled:
		%Shoot.pitch_scale = randf_range(1.0, 2.0)
		%Shoot.play()
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		%ShootingPoint.add_child(new_bullet)


func _on_player_health_depleted() -> void:
	disabled = true
