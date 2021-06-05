extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node("pointer").selected == 0:
		get_node("MenuStart").set("custom_colors/font_color", Color(1.2,1,0))
		get_node("MenuOption").set("custom_colors/font_color", Color(1,1,1))
		get_node("MenuExit").set("custom_colors/font_color", Color(1,1,1))
	elif get_node("pointer").selected == 1:
		get_node("MenuStart").set("custom_colors/font_color", Color(1,1,1))
		get_node("MenuOption").set("custom_colors/font_color", Color(1.2,1,0))
		get_node("MenuExit").set("custom_colors/font_color", Color(1,1,1))
	elif get_node("pointer").selected == 2:
		get_node("MenuStart").set("custom_colors/font_color", Color(1,1,1))
		get_node("MenuOption").set("custom_colors/font_color", Color(1,1,1))
		get_node("MenuExit").set("custom_colors/font_color", Color(1.2,1,0))
	if Input.is_action_just_pressed("ui_accept"):
		if get_node("pointer").selected == 0:
			get_node("/root/Global/Sounds/CursorMove").play()
			get_tree().change_scene("res://Scenes/Game/GamePlay.tscn")
		elif get_node("pointer").selected == 1:
			get_node("/root/Global/Sounds/InvalidInput").play()
		elif get_node("pointer").selected == 2:
			get_tree().quit()
