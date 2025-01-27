class_name Health
extends Node


@export var health: float = 100.0
@export var is_dead: bool = false

func take_damage(amount) -> void:
	health -= amount
	
	if health <= 0:
		is_dead = true
		
		if owner.has_method("die"):
			owner.die()
