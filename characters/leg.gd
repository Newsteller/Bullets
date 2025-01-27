extends Node2D


@export var collision_shape: CollisionShape2D
@export var is_flipped: bool = false

const MIN_DISTANCE: float = 200.0

var max_length = 300.0


func _ready() -> void:
	setup_joints()
	
	#$GroundFinder.force_raycast_update()
	
	if is_flipped:
		flip()
	

func _physics_process(delta: float) -> void:
	%FootTarget.position.y = min(max_length, to_local(%GroundFinder.get_collision_point()).y)
	print(%KneeBone.global_position, %FootBone.global_position)


func setup_joints() -> void:
	%KneeBone.position.y = max_length/2
	%FootBone.position.y = max_length/2
	%HipBoneColor.size.y = max_length/2
	%FootBoneColor.size.y = max_length/2

func flip() -> void:
	var modification_stack = %Skeleton2D.get_modification_stack() as SkeletonModificationStack2D
	var modification = modification_stack.get_modification(0) as SkeletonModification2DCCDIK
	var angle_min = rad_to_deg(modification.get_ccdik_joint_constraint_angle_min(1))
	var angle_max = rad_to_deg(modification.get_ccdik_joint_constraint_angle_max(1))
	
	modification.set_ccdik_joint_constraint_angle_min(1, deg_to_rad(-angle_min))
	modification.set_ccdik_joint_constraint_angle_max(1, deg_to_rad(-angle_max))
