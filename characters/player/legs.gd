extends Node2D


@export var origin_left: Marker2D
@export var origin_right: Marker2D

var offset
var offset_left
var offset_right
var reset_targets = true

func _ready() -> void:
	offset = %MoveTo.position - %MoveFrom.position
	setup_bones()


func _physics_process(delta: float) -> void:
	if reset_targets and %GroundDetector.is_colliding():
		%LeftTarget.position = %GroundDetector.get_collision_point() + (offset / 2)
		%RightTarget.position = %GroundDetector.get_collision_point() - (offset / 2)
		reset_targets = false
	
	move_targets()


func setup_bones() -> void:
	%KolanoPrawe.position = origin_right.position
	%KolanoLewe.position = origin_left.position


func move_targets() -> void:
	#print(to_local(%LeftTarget.position), " ", %MoveFrom.position)
	if to_local(%LeftTarget.position) < %MoveFrom.position:
		#print('przesuwam lewa')
		%LeftTarget.position = %MoveTo.get_collision_point()
	
	if to_local(%RightTarget.position) < %MoveFrom.position:
		#print('przesuwam prawa')
		%RightTarget.position = %MoveTo.get_collision_point()
	
	pass
