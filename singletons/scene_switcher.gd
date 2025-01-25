extends Node


var current_scene = null


func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(-1)


func replace_scene(scene_from, scene_to):
	scene_from.queue_free()
	current_scene = load(scene_to).instantiate()
	get_tree().root.get_child(-1).add_child(current_scene)


func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)


func _deferred_switch_scene(res_path):
	current_scene.free()
	var s = load(res_path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
