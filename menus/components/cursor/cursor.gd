extends Node2D


const CURSOR_HAND_PRESSED := preload("res://assets/cursors/hand_pressed.png")
const CURSOR_HAND_UNPRESSED := preload("res://assets/cursors/hand_unpressed.png")


func mouse_pressed() -> void:
	Input.set_custom_mouse_cursor(CURSOR_HAND_PRESSED, Input.CURSOR_POINTING_HAND, Vector2(10, 10))


func mouse_released() -> void:
	Input.set_custom_mouse_cursor(CURSOR_HAND_UNPRESSED, Input.CURSOR_POINTING_HAND, Vector2(10, 10))
