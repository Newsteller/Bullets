extends RigidBody2D

@export var speed = 750.0
@export var range = 1000.0

var travelled_distance = 0


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	%Projectile.set_rotation(state.linear_velocity.angle())
	travelled_distance += speed * state.step


func _on_body_entered(body: Node2D) -> void:
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
	
 
