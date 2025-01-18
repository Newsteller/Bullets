extends Sprite2D

const BULLET_HOLES = [
	preload("res://menus/main_menu/bullet_holes/bullet_hole_1.png"),
	preload("res://menus/main_menu/bullet_holes/bullet_hole_2.png"),
	preload("res://menus/main_menu/bullet_holes/bullet_hole_3.png"),
	preload("res://menus/main_menu/bullet_holes/bullet_hole_4.png"),
	preload("res://menus/main_menu/bullet_holes/bullet_hole_5.png")
]

func _init() -> void:
	texture = BULLET_HOLES[randf_range(0, 4)]
	self_modulate = Color.BISQUE
