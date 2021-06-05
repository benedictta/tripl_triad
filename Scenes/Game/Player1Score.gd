extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const CARDS_TEXT_PATH = "res://assets/card-element.png"
const SCORE_TEXT_WIDTH = 94
const SCORE_TEXT_HEIGHT = 99
const TEXTURE_START_OFFSET_H = 12
const TEXTURE_START_OFFSET_Y = 190

var value: int = 5  # valid numbers are from 1 to 9

func _ready():
	# update texture region
	update_score_texture(value)

func update_score_texture(value):
	assert(value >= 1 and value <= 9)
	texture.region = Rect2(
		TEXTURE_START_OFFSET_H + SCORE_TEXT_WIDTH * (value - 1),
		TEXTURE_START_OFFSET_Y,
		SCORE_TEXT_WIDTH,
		SCORE_TEXT_HEIGHT
	)# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
