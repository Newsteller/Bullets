class_name Player
extends CharacterBody2D


@export var sprite: CompressedTexture2D
@export var debug: bool = false

const UP_DIRECTION: Vector2 = Vector2.UP


@export var move_acceleration: float = 50
@export var move_max_speed: float = 500.0

@export_category("Jump")
@export var jump_strength: float = 1000.0
@export var jump_stop_multiplier: float = 0.7
@export var jump_coyote_time: float = 0.07
@export var max_jumps: int = 1

@export_category("Fall")
@export var max_fall_speed: float = 1000.0
@export var wall_fall_speed: float = 100.0
@export var wall_jump_pushback: float = 300.0

@export var gravity: float = 45.0
@export var is_flipped: bool = false

var horizontal_direction: float = 0.0

var fall_speed: float = 0.0

var jumps_made_counter: int = 0

var coyote_time_timer: Timer
var coyote_time_started = false

@onready var wall_detector: RayCast2D = %WallDetector

func _ready() -> void:
	setup_coyote_time_timer()


func setup_coyote_time_timer() -> void:
	coyote_time_timer = Timer.new()
	coyote_time_timer.one_shot = true
	add_child(coyote_time_timer)


# Leftover after multiplayer integration
var do_jump = false
