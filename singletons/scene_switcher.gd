extends Node


var current_scene = null


func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(-1)


func move_to_scene(res_path):
	var s = load(res_path)
	current_scene = s.instantiate()
	current_scene.queue_free()
	get_tree().current_scene.add_child(current_scene)
	#get_tree().current_scene = current_scene


func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)


func _deferred_switch_scene(res_path):
	current_scene.free()
	var s = load(res_path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
