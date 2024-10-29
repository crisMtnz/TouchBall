extends Node
var highScores = [0,0]
var gameMode = 2

var debug_text = "df"

#writes on the final screen
func getData():
	return "HIGHSCORE: " + str(highScores[gameMode-1])

func playSound(s):
	for i in get_children():
		if i.name == s:
			i.play()

func saveData():
	var saveDict = {
					"highScores" : highScores
					}
	var saveJson = JSON.new()
	saveJson = saveJson.stringify(saveDict)
	var f = FileAccess.open("user://highscores.json", FileAccess.WRITE)
	f.store_line(saveJson)
	
	debug_text = (
					"DATA SAVED. \n" + 
					"saveDict: " + str(saveDict) + "\n" + 
					"saveJson: " + str(saveJson)
				)

func loadData():
	if FileAccess.file_exists("user://highscores.json"):
		var f = FileAccess.open("user://highscores.json", FileAccess.READ)

		var json_string = f.get_line()
		if json_string == "":
			highScores = [0,0]
			return
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.get_data()
		
		highScores = node_data["highScores"]
		
	else:
		highScores = [0,0]
	
	debug_text = (
					"DATA LOADED. \n" + 
					"highscores: " + str(highScores) + "\n" + 
					"type: " + str(typeof(highScores))
				)
