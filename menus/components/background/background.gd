extends Node2D


const BULLET_HIT := preload("res://menus/components/background/bullet_hit/bullet_hit.tscn")
const BULLET_HOLE = preload("res://menus/components/background/bullet_holes/bullet_hole.tscn")


func _ready() -> void:
	set_background()


func _process(delta: float) -> void:
	animate_background()


func set_background() -> void:
	var viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var viewport_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	%Background.size = Vector2(viewport_width*2, viewport_height*2)


func animate_background() -> void:
	var current_mouse_position = get_global_mouse_position()
	var screen_center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
	var offset = (screen_center * -0.5 - current_mouse_position) * 0.5
	
	if %Background.get_screen_position() != offset:
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(%Background, "position", offset, 1.0)


func shoot_background():
	if Input.get_current_cursor_shape() == Input.CURSOR_ARROW:
		add_item_at_mouse_position(BULLET_HOLE)
		add_item_at_mouse_position(BULLET_HIT)


func add_item_at_mouse_position(item):
	var temp = item.instantiate()
	temp.global_position = get_global_mouse_position() - %Background.get_screen_position()
	temp.rotation_degrees = randf_range(0, 360)
	%Background.add_child(temp)
