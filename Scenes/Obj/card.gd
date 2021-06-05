extends TextureButton
export var OwnedbyPlayer = true
export var covered = false
export var card_id = 0

const CARDS_DATA_PATH = "res://data/triple-triad-cards-data.json"
const CARDS_PATH = "res://assets/"
const CARD_HEIGHT = 184
const CARD_WIDTH = 184
const CARDS_PER_ROW = 2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var card = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	var card_data
	var cards = _load_cards_data_from_json()
	for c in cards:
		if c.id == card_id:
			card_data = c
	card.group = card_data["group"]
	card.group_index = card_data["group_index"]
	card.name = card_data["name"]
	card.attributes = {
		"top": int(card_data["attributes"][0]),
		"right": int(card_data["attributes"][1]),
		"bottom": int(card_data["attributes"][2]),
		"left": int(card_data["attributes"][3]),
	}
	# set attributes GUI
	$Attributes.set_attributes(card.attributes)
	card.front_texture = _get_atlas_texture_by_group_and_index(card.group, card.group_index)
	card.back_texture = _get_atlas_texture_by_group_and_index(13, 6)
	if covered:
		$Attributes.hide()
		texture_normal = card.back_texture
	else:
		$Attributes.show()
		texture_normal = card.front_texture
	if OwnedbyPlayer == true:
		$PlayerTexture.show()
		$EnemyTexture.hide() 
	else:
		$PlayerTexture.hide()
		$EnemyTexture.show()# Replace with function body.

func _load_cards_data_from_json():
	var file = File.new()
	var exit_code = file.open(CARDS_DATA_PATH, file.READ)
	if exit_code != 0:
		print("Error", exit_code, "while opening", CARDS_DATA_PATH)
	var file_data = file.get_as_text()
	var error_str = validate_json(file_data)
	if not error_str:
		# JSON is valid
		return parse_json(file_data)
	else:
		prints("Invalid JSON\n", error_str)

func _get_atlas_texture_by_group_and_index(c_group, c_index):
	# load the correct texture
	var t = AtlasTexture.new()
	# load a texture resource into the "atlas" Texture field
	t.atlas = load(CARDS_PATH + "cards_{grp}.png".format({"grp": int(c_group)}))
	# set the region
	t.region = Rect2(
		(int(c_index) % CARDS_PER_ROW)*192+3,
		(int(c_index) / CARDS_PER_ROW)*192+3,
		CARD_WIDTH,
		CARD_HEIGHT
	)
	return t
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if OwnedbyPlayer == true:
		$PlayerTexture.show()
		$EnemyTexture.hide() 
	else:
		$PlayerTexture.hide()
		$EnemyTexture.show()
