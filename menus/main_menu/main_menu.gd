extends Node

const TITLE = preload("res://menus/title/title.tscn")
const SETTINGS = preload("res://menus/settings/settings.tscn")

func _ready() -> void:
	add_child(TITLE.instantiate())


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		%Cursor.mouse_pressed()
		%Background.shoot_background()
		
	if Input.is_action_just_released("shoot"):
		%Cursor.mouse_released()
