class_name BaseBulletStrategy
extends Resource


@export var texture: CompressedTexture2D = preload("res://base_bullet_strategy/bullet.png")
@export var upgrade_text: String = "Upgrade text"


func apply_upgrade(bullet: Bullet) -> void:
	pass

func apply_to_hit(player: Player):
	pass
