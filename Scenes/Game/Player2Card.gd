extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# update the seed
	randomize()
	# randomize Player cards
	randomize_cards()

func randomize_cards():
	# for each child
	for child in get_children():
		# if it is a Container
		if "Container" in child.name:
			# get the Card node
			var card = child.get_child(0)
			card.card_id = randi() % 110  # max card id is 109
			card._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
