extends Button


@onready var base_button: Button = $"."
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D


func _ready() -> void:
	var new_shape = RectangleShape2D.new()
	new_shape.size = base_button.size
	collision_shape_2d.shape = new_shape
