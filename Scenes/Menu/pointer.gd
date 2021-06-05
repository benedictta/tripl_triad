extends Sprite
var selected = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	position.y = get_parent().get_child(selected).margin_bottom-40# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func _process(delta):
	if Input.is_action_just_released("ui_down"):
		if selected < 2:
			selected = selected+1
			position.y = get_parent().get_child(selected).margin_bottom-40
		get_node("/root/Global/Sounds/CursorMove").play()
	if Input.is_action_just_released("ui_up"):
		if selected > 0:
			selected = selected-1
			position.y = get_parent().get_child(selected).margin_bottom-40
		get_node("/root/Global/Sounds/CursorMove").play()
