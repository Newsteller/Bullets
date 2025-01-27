extends Node


func _process(delta: float) -> void:
	Steam.leaderboard_score_uploaded.connect(leaderboard_uploaded)
	Steam.leaderboard_scores_downloaded.connect(leaderboard_downloaded)

func leaderboard_uploaded(success: int, handle: int, score):
	# score: { score: int, score_changed: int, global_rank_new: int, global_rank_prev: int }
	if success != 1:
		print("Leaderboard upload failed!")
	else:
		print("State: ", success, ", Handle: ", handle, ", Score: ", score)

func leaderboard_downloaded(message, handle, result):
	# result: { score: int, steam_id: int, global_rank: int, ugc_handle: int }
	print("Message: ", message, ", Handle: ", handle, ", Result: ", result)
