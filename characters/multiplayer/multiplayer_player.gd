class_name MultiplayerPlayer
extends CharacterBody2D


@onready var sprite: Sprite2D = %CharacterSprite:
	get: return sprite

@onready var collision_shape: CollisionShape2D = %CollisionShape2D:
	get: return collision_shape

@onready var wall_detector: RayCast2D = %WallDetector:
	get: return wall_detector

var do_jump = false
