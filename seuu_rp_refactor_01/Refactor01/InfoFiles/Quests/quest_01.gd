extends Resource

enum QuestStatus {HIDDEN,AVAILABLE,ACTIVE,COMPLETE}

var quest_name: String = "Complete the tutorial races"
var quest_tasks = [
	load("res://Refactor01/InfoFiles/Quests/Tasks/task_01.gd").new(),
	load("res://Refactor01/InfoFiles/Quests/Tasks/task_02.gd").new()
]
var current_status = QuestStatus.ACTIVE
