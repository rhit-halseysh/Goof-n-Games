extends Control


func _level_complete():
	SceneManager.goto_scene()

func _ready():
	GameData.level_number += 1
	GameData.next_level = "res://Levels/Level%d.tscn" % GameData.level_number
	
func _exit():
	get_tree().quit()
