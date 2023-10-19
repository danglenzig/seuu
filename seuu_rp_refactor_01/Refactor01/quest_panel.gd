extends Panel

##################################################
var my_name: String = "quest_panel.gd"
func print_to_console(the_string: String):
	print(str(my_name, " says: ", the_string))
##################################################

var quests = [
	load("res://Refactor01/InfoFiles/Quests/quest_01.gd").new()
]
var current_quest

var quest_name_text: Label
var task_list_text: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	quest_name_text = get_node("QuestNameLabel")
	task_list_text = get_node("TaskListLabel")
	current_quest = quests[0]
	set_quest_name(current_quest.quest_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_quest_name(the_string: String):
	quest_name_text.set_text(the_string)
	
func set_quest_tasks_text():
	pass
