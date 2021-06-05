extends VBoxContainer
var select = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	update_banner()
	update_results()# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		if(select < 1):
			$EndPointer.position.y = $EndPointer.position.y + 45
			select = select+1
		$"/root/Global/Sounds/CursorMove".play()
	if Input.is_action_just_pressed("ui_up"):
		if(select>0):
			$EndPointer.position.y = $EndPointer.position.y - 45
			select = select -1
		$"/root/Global/Sounds/CursorMove".play()
	if Input.is_action_just_pressed("ui_accept"):
		if(select == 0):
			get_tree().change_scene("res://Scenes/Game/GamePlay.tscn")
		elif(select==1):
			get_node("/root/Global/Sounds/GamePlay").stop()
			get_tree().change_scene("res://Scenes/Menu/MainMenu.tscn")
		get_node("/root/Global/Sounds/CursorMove").play()

func update_banner():
	if($"/root/Global".Last_match=="win"):
		$WinTexture.show()
		$DrawTexture.hide()
		$LoseTexture.hide()
	if($"/root/Global".Last_match=="lose"):
		$WinTexture.hide()
		$DrawTexture.hide()
		$LoseTexture.show()
	if($"/root/Global".Last_match=="draw"):
		$WinTexture.hide()
		$DrawTexture.show()
		$LoseTexture.hide()
func update_results():
	$MarginContainer/Stat/Matches/Value.text = str($"/root/Global".matches)
	$MarginContainer/Stat/MatchesWon/Value.text = str($"/root/Global".win)
	$MarginContainer/Stat/MatchesDraw/Value.text = str($"/root/Global".draw)
	$MarginContainer/Stat/MatchesLost/Value.text = str($"/root/Global".lose)
