extends Control


const CURSOR_HAND_PRESSED := preload("res://assets/cursors/hand_pressed.png")
const CURSOR_HAND_UNPRESSED := preload("res://assets/cursors/hand_unpressed.png")
const BULLET_HIT := preload("res://menus/main_menu/bullet_hit.tscn")
const BULLET_HOLE = preload("res://menus/main_menu/bullet_holes/bullet_hole.tscn")


@onready var main_menu: Control = $"."
@onready var bullet_hit: AnimatedSprite2D = $BulletHit
@onready var background: TextureRect = %Background


var offset


func _init() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	Input.set_custom_mouse_cursor(CURSOR_HAND_UNPRESSED, Input.CURSOR_POINTING_HAND, Vector2(10, 10))


func _ready() -> void:
	var viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var viewport_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	background.size = Vector2(viewport_width*2, viewport_height*2)
	

func _process(_delta: float) -> void:
	var current_mouse_position = get_global_mouse_position()
	offset = (get_screen_center() * -0.5 - current_mouse_position) * 0.5
	if %Background.get_screen_position() != offset:
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property($Background, "position", offset, 1.0)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() == true:
			Input.set_custom_mouse_cursor(CURSOR_HAND_PRESSED, Input.CURSOR_POINTING_HAND, Vector2(10, 10))
			shoot()
		else:
			Input.set_custom_mouse_cursor(CURSOR_HAND_UNPRESSED, Input.CURSOR_POINTING_HAND, Vector2(10, 10))


func _on_play_button_pressed() -> void:
	pass # Replace with function body.


func _on_options_button_pressed() -> void:
	var options_instance = preload("res://menus/options/options.tscn").instantiate()
	get_tree().current_scene.add_child(options_instance)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func get_screen_center() -> Vector2:
	return Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)


func shoot():
	if Input.get_current_cursor_shape() == Input.CURSOR_ARROW:
		add_item_at_mouse_position(BULLET_HOLE)
		add_item_at_mouse_position(BULLET_HIT)


func add_item_at_mouse_position(item):
	var temp = item.instantiate()
	temp.global_position = get_global_mouse_position() - %Background.get_screen_position()
	temp.rotation_degrees = randf_range(0, 360)
	%Background.add_child(temp)
