extends Node


func aquire_achivement(achivementName: String):
	var achivement = Steam.getAchievement(achivementName)
	
	if achivement.ret && !achivement.achived:
		Steam.setAchievement(achivementName)
		Steam.storeStats()
