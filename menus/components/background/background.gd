extends Node2D


const BULLET_HIT := preload("res://menus/components/background/bullet_hit/bullet_hit.tscn")
const BULLET_HOLE = preload("res://menus/components/background/bullet_holes/bullet_hole.tscn")
const MOVEMENT_MULTIPLIER = 0.5


var viewport_width
var viewport_height


func _ready() -> void:
	set_background()


func _process(_delta: float) -> void:
	animate_background()


func set_background() -> void:
	viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	viewport_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	%Background.size = Vector2(viewport_width, viewport_height)
	%Background.size += %Background.size * MOVEMENT_MULTIPLIER


func animate_background() -> void:
	var screen_center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
	var offset = ((screen_center - mouse_position() - background_offset_position()) * MOVEMENT_MULTIPLIER) 

	
	if %Background.get_screen_position() != offset:
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(%Background, "position", offset, 1.0)


func background_offset_position() -> Vector2:
	return Vector2(viewport_width, viewport_height) / 2


func mouse_position() -> Vector2:
	var mouse_position = get_global_mouse_position()
	mouse_position.x = max(0, mouse_position.x)
	mouse_position.x = min(viewport_width, mouse_position.x)
	mouse_position.y = max(0, mouse_position.y)
	mouse_position.y = min(viewport_height, mouse_position.y)
	
	return Vector2(mouse_position.x, mouse_position.y)


func shoot_background():
	if Input.get_current_cursor_shape() == Input.CURSOR_ARROW:
		add_item_at_mouse_position(BULLET_HOLE)
		add_item_at_mouse_position(BULLET_HIT)


func add_item_at_mouse_position(item):
	var temp = item.instantiate()
	temp.global_position = get_global_mouse_position() - %Background.get_screen_position()
	temp.rotation_degrees = randf_range(0, 360)
	%Background.add_child(temp)
