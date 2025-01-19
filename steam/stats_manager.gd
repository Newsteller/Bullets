extends Node


var stats = {}


func get_int_stat(statName: String) -> int:
	var value = Steam.getStatInt(statName)
	stats[statName] = value
	return value


func get_float_stat(statName: String) -> float:
	var value = Steam.getStatFloat(statName)
	stats[statName] = value
	return value


func set_int_stat(statName: String, value: int) -> void:
	Steam.setStatInt(statName, value)
	Steam.storeStats()


func set_float_stat(statName: String, value: float) -> void:
	Steam.setStatFloat(statName, value)
	Steam.storeStats()
