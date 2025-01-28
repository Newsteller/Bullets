class_name Movement
extends Node

const UP_DIRECTION: Vector2 = Vector2.UP


@export var move_max_speed: float = 500.0
@export var move_acceleration: float = 50

@export_category("Jump")
@export var jump_strength: float = 800.0
@export var jump_stop_multiplier: float = 0.7
## Describe that value as a multipier of current FPS.
@export var jump_buffer_time: float = 0.2
## Describe that value as a multipier of current FPS.
@export var jump_coyote_time: float = 0.1
@export var max_jumps: int = 1

@export_category("Fall")
@export var max_fall_speed: float = 1000.0
@export var wall_fall_speed: float = 200.0

@export var gravity := 55.0

var _fps: int = 0

var _fall_speed: float = 0.0
var _is_flipped: bool = false
var _jumps_made_counter: int = 0
var _jump_buffer_counter: int = 0
var _jump_coyote_counter: int = 0

@onready var player: Player
@onready var _wall_detector_init_position: Vector2
@onready var _wall_detector_init_target_position: Vector2

func _ready() -> void:
	_fps = ProjectSettings.get_setting("physics/common/physics_ticks_per_second")
	player = owner


func _physics_process(_delta: float) -> void:
	# Gimmick to get that values when character is not null
	if player and not (_wall_detector_init_position and player.wall_detector.target_position):
		_wall_detector_init_position = player.wall_detector.position
		_wall_detector_init_target_position = player.wall_detector.target_position
	
	if player.is_on_floor():
		_jump_coyote_counter = floori(jump_coyote_time * _fps)
		_jumps_made_counter = 0
	
	if not player.is_on_floor():
		_jump_coyote_counter -= 1
		player.velocity.y += gravity
		player.velocity.y = min(player.velocity.y, _fall_speed)
	
	var _horizontal_direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	player.velocity.x += _horizontal_direction * move_acceleration
	
	check_if_flip(_horizontal_direction)
	
	if _horizontal_direction == 0:
		player.velocity.x = lerpf(player.velocity.x, 0.0, 0.2)
		
	player.velocity.x = clampf(player.velocity.x, -move_max_speed, move_max_speed)
	
	
	if player.wall_detector.is_colliding() and player.wall_detector.get_collider().name == "TileMapLayer" and _horizontal_direction != 0:
		_fall_speed = wall_fall_speed
	else:
		_fall_speed = max_fall_speed
	
	if Input.is_action_just_pressed("jump"):
		_jump_buffer_counter = floori(jump_buffer_time * _fps)
	
	if _jump_buffer_counter > 0:
		_jump_buffer_counter -= 1
		do_jump()
	
	if Input.is_action_just_released("jump"):
		cancel_jump()
	
	player.move_and_slide()


func check_if_flip(direction: float) -> void:
	if direction < 0.0:
		_is_flipped = true
		player.wall_detector.position = -_wall_detector_init_position
		player.wall_detector.target_position = -_wall_detector_init_target_position
	elif direction > 0.0:
		_is_flipped = false
		player.wall_detector.position = _wall_detector_init_position
		player.wall_detector.target_position = _wall_detector_init_target_position
		
	player.sprite.flip_h = _is_flipped

func do_jump() -> void:
	if player.wall_detector.is_colliding():
		if player.wall_detector.get_collider().name == "TileMapLayer":
			player.velocity.y = -jump_strength
			if _is_flipped:
				player.velocity.x += jump_strength / 3
			else: 
				player.velocity.x -= jump_strength / 3
		
	elif _jump_coyote_counter > 0:
		player.velocity.y = -jump_strength
		_jumps_made_counter += 1
		_jump_buffer_counter = 0
		_jump_coyote_counter = 0
		
	elif _jumps_made_counter < max_jumps:
		player.velocity.y = -jump_strength
		_jumps_made_counter += 1
		_jump_buffer_counter = 0
		_jump_coyote_counter = 0


func cancel_jump() -> void:
	if player.velocity.y < 0.0:
		player.velocity.y = lerpf(player.velocity.y, 0.0, jump_stop_multiplier)
