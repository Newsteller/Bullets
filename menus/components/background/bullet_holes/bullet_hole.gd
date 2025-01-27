extends Sprite2D

const BULLET_HOLES = [
	preload("res://menus/components/background/bullet_holes/bullet_holes_assets/bullet_hole_1.png"),
	preload("res://menus/components/background/bullet_holes/bullet_holes_assets/bullet_hole_2.png"),
	preload("res://menus/components/background/bullet_holes/bullet_holes_assets/bullet_hole_3.png"),
	preload("res://menus/components/background/bullet_holes/bullet_holes_assets/bullet_hole_4.png"),
	preload("res://menus/components/background/bullet_holes/bullet_holes_assets/bullet_hole_5.png")
]

func _init() -> void:
	texture = BULLET_HOLES.pick_random()
	self_modulate = Color.BISQUE
