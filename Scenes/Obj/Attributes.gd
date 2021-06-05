extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const ATTRIBUTE_TEXTURE_WIDTH = 64
const TEXTURE_OFFSET = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	$Top.texture = $Top.texture.duplicate()
	$Bottom.texture = $Bottom.texture.duplicate()
	$Right.texture = $Right.texture.duplicate()
	$Left.texture = $Left.texture.duplicate() # Replace with function body.

func set_attributes(attributes_data):
	$Top.texture.region = _get_texture_region_by_value(attributes_data["top"])
	$Left.texture.region = _get_texture_region_by_value(attributes_data["left"])
	$Right.texture.region = _get_texture_region_by_value(attributes_data["right"])
	$Bottom.texture.region = _get_texture_region_by_value(attributes_data["bottom"])

func _get_texture_region_by_value(value):
	return Rect2(
		TEXTURE_OFFSET + (value)*ATTRIBUTE_TEXTURE_WIDTH, 
		TEXTURE_OFFSET, 
		32, 
		32
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
