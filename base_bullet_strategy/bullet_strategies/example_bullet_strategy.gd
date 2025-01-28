class_name ExampleBulletStrategy
extends BaseBulletStrategy


var particle_scene: PackedScene = preload("res://base_bullet_strategy/bullet_strategies/particle_scene.tscn")

func apply_upgrade(bullet: Bullet) -> void:
	var spawned_particles: Node2D = particle_scene.instantiate()
	spawned_particles.global_position = bullet.global_position
	bullet.add_child(spawned_particles)
