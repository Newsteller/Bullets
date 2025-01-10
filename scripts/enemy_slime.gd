extends CharacterBody2D

const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var health = 3.0

@onready var player = $/root/Game/Player

func _ready() -> void:
	$Slime.play_walk()

func _physics_process(delta: float) -> void:

	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED

	move_and_slide()


func take_damage() -> void:
	health -= 1
	%Slime.play_hurt()
	%DamageSound.pitch_scale = randf_range(1.0, 3.0)
	%DamageSound.play()
	
	if health <= 0:
		queue_free()
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
