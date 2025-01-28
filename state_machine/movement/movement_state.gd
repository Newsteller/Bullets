class_name MovementState
extends State

const IDLE = "IdleState"
const RUNNING = "RunningState"
const JUMPING = "JumpingState"
const FALLING = "FallingState"
const WALL_SLIDING = "WallSlidingState"

var player: Player

@onready var _wall_detector_init_position = %WallDetector.position
@onready var _wall_detector_init_target_position = %WallDetector.target_position


func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The MovementState state type must be used only in the player scene. It needs the owner to be a MultiplayerPlayer node.")


func move_to_sides() -> void:
	var _horizontal_direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	player.velocity.x += _horizontal_direction * player.move_acceleration
	if is_equal_approx(_horizontal_direction, 0.0):
		player.velocity.x = lerpf(player.velocity.x, 0.0, 0.2)
		
	player.velocity.x = clampf(player.velocity.x, -player.move_max_speed, player.move_max_speed)
	
	check_if_flip(_horizontal_direction)


func calculate_gravity() -> void:
	player.velocity.y += player.gravity
	player.velocity.y = min(player.velocity.y, player.fall_speed)


func check_if_flip(direction: float) -> void:
	if direction < 0.0:
		player.is_flipped = true
		%WallDetector.position = -_wall_detector_init_position
		%WallDetector.target_position = -_wall_detector_init_target_position
	elif direction > 0.0:
		player.is_flipped = false
		%WallDetector.position = _wall_detector_init_position
		%WallDetector.target_position = _wall_detector_init_target_position
		
	%CharacterSprite.flip_h = player.is_flipped
