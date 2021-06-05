extends Control
onready var PCard0 = $Player1Card/Container0/card
onready var PCard1 = $Player1Card/Container1/card
onready var PCard2 = $Player1Card/Container2/card
onready var PCard3 = $Player1Card/Container3/card
onready var PCard4 = $Player1Card/Container4/card
onready var PlayerCard = [PCard0,PCard1,PCard2,PCard3,PCard4]

onready var oCard0 = $Player2Card/Container0/card
onready var oCard1 = $Player2Card/Container1/card
onready var oCard2 = $Player2Card/Container2/card
onready var oCard3 = $Player2Card/Container3/card
onready var oCard4 = $Player2Card/Container4/card
onready var OpponentCard = [oCard0,oCard1,oCard2,oCard3,oCard4]

onready var FieldMatrix = [
	[$Field/Container0,$Field/Container1,$Field/Container2],
	[$Field/Container3,$Field/Container4,$Field/Container5],
	[$Field/Container6,$Field/Container7,$Field/Container8]
]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playerTotalCard = 5
var aiTotalCard = 5
var cont_i = 1
var cont_j = 1
var aii = 0
var aij = 0
var CurrentSelectedCard = 0
var PrevSelectedCard = -1
var SelectCard = true
var PlayerTurn
var AiTurn
var CardPlayed = 0
var current_attributes
var ai_current_attributes
var player_state = "win"
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	PlayerTurn  = randi()%2
	if PlayerTurn==1:
		AiTurn=0
		PlayerCard[CurrentSelectedCard].rect_position.x = PlayerCard[CurrentSelectedCard].rect_position.x + 50
	elif PlayerTurn==0:
		AiTurn=1
	$FieldPointer.hide()
	get_node("/root/Global/Sounds/GamePlay").play()
	$GamePointer.position.y = PlayerCard[CurrentSelectedCard].get_parent().margin_top + 130

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (PlayerTurn == 1):
		if(SelectCard):
			SelectingCard()
		elif(!SelectCard):
			placing_cards_on_container()
	elif(AiTurn==1):
		$GamePointer.hide()
		$Player2Card/ChoosingAnim.play("Load")
		$Player2Card/ChoosingAnim.emit_signal("animation_finished")
	if (CardPlayed == 9):
		if(aiTotalCard>playerTotalCard):
			player_state="lose"
		elif(aiTotalCard == playerTotalCard):
			player_state = "draw"
		yield(get_tree().create_timer(2.5), "timeout")
		game_end()

func SelectingCard():
	if Input.is_action_just_released("ui_down"):
		if CurrentSelectedCard < PlayerCard.size()-1:
			PrevSelectedCard = CurrentSelectedCard
			CurrentSelectedCard = CurrentSelectedCard+1
			$GamePointer.position.y = PlayerCard[CurrentSelectedCard].get_parent().margin_top + 130
			PlayerCard[CurrentSelectedCard].rect_position.x = PlayerCard[CurrentSelectedCard].rect_position.x + 50
			PlayerCard[PrevSelectedCard].rect_position.x = PlayerCard[PrevSelectedCard].rect_position.x - 50
		get_node("/root/Global/Sounds/CursorMove").play()
	if Input.is_action_just_released("ui_up"):
		if CurrentSelectedCard > 0:
			PrevSelectedCard = CurrentSelectedCard
			CurrentSelectedCard = CurrentSelectedCard-1
			$GamePointer.position.y = PlayerCard[CurrentSelectedCard].get_parent().margin_top + 130
			PlayerCard[CurrentSelectedCard].rect_position.x = PlayerCard[CurrentSelectedCard].rect_position.x + 50
			PlayerCard[PrevSelectedCard].rect_position.x = PlayerCard[PrevSelectedCard].rect_position.x - 50
		get_node("/root/Global/Sounds/CursorMove").play()
	if Input.is_action_just_pressed("ui_accept"):
		if (!PlayerCard.empty()):
			SelectCard = false
			get_node("/root/Global/Sounds/CursorMove").play()

func placing_cards_on_container():
	var CardToPlace = PlayerCard[CurrentSelectedCard]
	$GamePointer.modulate.a = 0.5
	$FieldPointer.position.x = FieldMatrix[cont_i][cont_j].margin_right + 150
	$FieldPointer.position.y = FieldMatrix[cont_i][cont_j].margin_bottom - 75
	$FieldPointer.show()
	if Input.is_action_just_pressed("ui_cancel"):
		$GamePointer.modulate.a = 1
		$FieldPointer.hide()
		cont_i = 1
		cont_j = 1
		$"/root/Global/Sounds/BackSound".play()
		SelectCard=true
	if Input.is_action_just_pressed("ui_left"):
		if(cont_j>0):
			cont_j = cont_j-1
		get_node("/root/Global/Sounds/CursorMove").play()
	if Input.is_action_just_pressed("ui_right"):
		if(cont_j<2):
			cont_j = cont_j+1
		get_node("/root/Global/Sounds/CursorMove").play()
	if Input.is_action_just_pressed("ui_up"):
		if(cont_i>0):
			cont_i = cont_i - 1
		get_node("/root/Global/Sounds/CursorMove").play()
	if Input.is_action_just_pressed("ui_down"):
		if(cont_i<2):
			cont_i = cont_i + 1
		get_node("/root/Global/Sounds/CursorMove").play()
	if Input.is_action_just_pressed("ui_accept"):
		if FieldMatrix[cont_i][cont_j].Empty == true:
			PlayerCard[CurrentSelectedCard].rect_position.x = PlayerCard[CurrentSelectedCard].rect_position.x - 50
			$Player1Card.remove_child(CardToPlace.get_parent())
			CardToPlace.get_parent().remove_child(CardToPlace)
			FieldMatrix[cont_i][cont_j].add_child(CardToPlace)
			FieldMatrix[cont_i][cont_j].Empty = false
			PlayerCaptureCard()
			PlayerCard.remove(CurrentSelectedCard)
			SelectCard = true
			$GamePointer.modulate.a = 1
			$FieldPointer.hide()
			CurrentSelectedCard = -1
			PrevSelectedCard = -1
			CardPlayed = CardPlayed+1
			if(PlayerCard.size()>0):
				$GamePointer.position.y = PlayerCard[0].get_parent().margin_top + 130
				PlayerTurn = 0
			if CardPlayed != 9:
				AiTurn = 1
				cont_i=1
				cont_j=1
			$GamePointer.hide()
			get_node("/root/Global/Sounds/PlacedCard").play()
			getPlayerState()
		elif FieldMatrix[cont_i][cont_j].Empty == false:
			$"/root/Global/Sounds/InvalidInput".play()
			
func ai_randomize_movement():
	randomize()
	var testEmpty = false
	var aiCardLeft = OpponentCard.size()
	var ai_select = randi()%aiCardLeft
	var ai_CardToPlace = OpponentCard[ai_select]
	while testEmpty == false:
		aii = randi()%3
		aij = randi()%3
		if(FieldMatrix[aii][aij].Empty==true):
			testEmpty = true
	$Player2Card.remove_child(ai_CardToPlace.get_parent())
	ai_CardToPlace.get_parent().remove_child(ai_CardToPlace)
	FieldMatrix[aii][aij].add_child(ai_CardToPlace)
	FieldMatrix[aii][aij].Empty = false
	aiCaptureCard()
	OpponentCard.remove(ai_select)

func getCurrentBoardState():
	var box00 = [0,0,0,0,null,true]
	var box01 = [0,0,0,0,null,true]
	var box02 = [0,0,0,0,null,true]
	var box10 = [0,0,0,0,null,true]
	var box11 = [0,0,0,0,null,true]
	var box12 = [0,0,0,0,null,true]
	var box20 = [0,0,0,0,null,true]
	var box21 = [0,0,0,0,null,true]
	var box22 = [0,0,0,0,null,true]
	var currentBoardState = [
		[box00,box01,box02],
		[box10,box11,box12],
		[box20,box21,box22]
	]
	var temp
	for i in range(3):
		for j in range(3):
			if FieldMatrix[i][j].Empty == false:
				temp = FieldMatrix[i][j].get_child(0).card.attributes
				currentBoardState[i][j] = [temp["left"],temp["right"],temp["top"],temp["bottom"],FieldMatrix[i][j].get_child(0).OwnedbyPlayer, false]
	return currentBoardState

func getAiState():
	var ocard = []
	for i in range(OpponentCard.size()):
		var temp = OpponentCard[i].card.attributes
		var c = [temp["left"],temp["right"],temp["top"],temp["bottom"],false]
		ocard.push_back(c)
	return ocard

func getPlayerState():
	var pcard = []
	for i in range(PlayerCard.size()):
		var temp = PlayerCard[i].card.attributes
		var c = [temp["left"],temp["right"],temp["top"],temp["bottom"],true]
		pcard.push_back(c)
	return pcard

func evaluateBoard(board,aiCards):
	var box
	var currentScore=0
	for i in range (3):
		for j in range(3):
			box = board[i][j]
			if box[5]==false:
				if box[4]==false:
					currentScore = currentScore+1
	var score = currentScore+aiCards.size()
	return score

func minimax(board, aiCards, playerCards, depth, isMaximizingPlayer,alpha,beta):
	var score
	var bestScore
	if(depth==0):
		score = evaluateBoard(board, aiCards)
		return score
	elif(depth!=0):
		if(isMaximizingPlayer):
			bestScore = -1000
			for i in range(3):
				for j in range(3):
					var boardState = board.duplicate(true)
					var box = boardState[i][j]
					if(box[5]==true):
						for c in range (aiCards.size()):
							var aiState = aiCards.duplicate(true)
							var card = aiState[c]
							for k in range(5):
								box[k] = card[k]
							box[5] = false
							aiState.remove(c)
							if(i>0):
								var top = boardState[i-1][j]
								if top[5]==false:
									if top[4]==true:
										if box[2]>top[3]:
											top[4] = false
							if(i<2):
								var bottom = boardState[i+1][j]
								if bottom[5]==false:
									if bottom[4]==true:
										if box[3]>bottom[2]:
											bottom[4] = false
							if(j>0):
								var left = boardState[i][j-1]
								if left[5]==false:
									if left[4]==true:
										if box[0]>left[1]:
											left[4] = false
							if(j<2):
								var right = boardState[i][j+1]
								if right[5]==false:
									if right[4]==true:
										if box[1]>right[0]:
											right[4] = false
							score = minimax(boardState,aiState,playerCards,depth-1,false,alpha,beta)
							bestScore=max(bestScore,score)
							alpha = max(alpha,bestScore)
							if beta <=alpha:
								break
							#print(score)
			#print(alpha)
			return bestScore
		if(!isMaximizingPlayer):
			bestScore = 1000
			for i in range(3):
				for j in range(3):
					var boardState = board.duplicate(true)
					var box = boardState[i][j]
					if(box[5]==true):
						for c in range (playerCards.size()):
							var playerState = playerCards.duplicate(true)
							var card = playerState[c]
							for k in range(5):
								box[k] = card[k]
							box[5] = false
							playerState.remove(c)
							if(i>0):
								var top = boardState[i-1][j]
								if top[5]==false:
									if top[4]==false:
										if box[2]>top[3]:
											top[4] = true
							if(i<2):
								var bottom = boardState[i+1][j]
								if bottom[5]==false:
									if bottom[4]==false:
										if box[3]>bottom[2]:
											bottom[4] = true
							if(j>0):
								var left = boardState[i][j-1]
								if left[5]==false:
									if left[4]==false:
										if box[0]>left[1]:
											left[4] = true
							if(j<2):
								var right = boardState[i][j+1]
								if right[5]==false:
									if right[4]==false:
										if box[1]>right[0]:
											right[4] = true
							score = minimax(boardState,aiCards,playerState,depth-1,true,alpha,beta)
							bestScore=min(bestScore,score)
							beta = min(beta,bestScore)
							if beta <=alpha:
								break
			#print(beta)
			return bestScore

func AI_move():
	var score
	var bestScore = -1000
	var bestMove = [-1,-1,-1]
	var board = getCurrentBoardState()
	var ai = getAiState()
	var player = getPlayerState()
	for i in range(3):
		for j in range(3):
			var boardState = board.duplicate(true)
			var box = boardState[i][j]
			if box[5]==true:
				for c in range(ai.size()):
					var aiState = ai.duplicate(true)
					var card = aiState[c]
					for k in range(5):
						box[k] = card[k]
					box[5]=false
					aiState.remove(c)
					if(i>0):
						var top = boardState[i-1][j]
						if top[5]==false:
							if top[4]==true:
								if box[2]>top[3]:
									top[4] = false
					if(i<2):
						var bottom = boardState[i+1][j]
						if bottom[5]==false:
							if bottom[4]==true:
								if box[3]>bottom[2]:
									bottom[4] = false
					if(j>0):
						var left = boardState[i][j-1]
						if left[5]==false:
							if left[4]==true:
								if box[0]>left[1]:
									left[4] = false
					if(j<2):
						var right = boardState[i][j+1]
						if right[5]==false:
							if right[4]==true:
								if box[1]>right[0]:
									right[4] = false
					if(CardPlayed<5):
						score = minimax(boardState,aiState,player,3,false,-1000,1000)
					else:
						score = minimax(boardState,aiState,player,8-CardPlayed,false,-1000,1000)
					if(bestScore<score):
						bestScore=score
						bestMove=[i,j,c]
	var ai_select = bestMove[2]
	aii = bestMove[0]
	aij = bestMove[1]
	var ai_CardToPlace = OpponentCard[ai_select]
	$Player2Card.remove_child(ai_CardToPlace.get_parent())
	ai_CardToPlace.get_parent().remove_child(ai_CardToPlace)
	FieldMatrix[aii][aij].add_child(ai_CardToPlace)
	FieldMatrix[aii][aij].Empty = false
	aiCaptureCard()
	OpponentCard.remove(ai_select)

func ai_turn():
	AI_move()
	#ai_randomize_movement()
	AiTurn = 0
	CardPlayed = CardPlayed+1
	if CardPlayed != 9:
		$GamePointer.show()
		CurrentSelectedCard = 0
		$GamePointer.position.y = PlayerCard[CurrentSelectedCard].get_parent().margin_top + 130
		PlayerCard[0].rect_position.x = PlayerCard[0].rect_position.x + 50
		PlayerTurn = 1
	get_node("/root/Global/Sounds/PlacedCard").play()

func PlayerCaptureCard():
	var top
	var left
	var right
	var bottom
	var iscapturing = false
	current_attributes = FieldMatrix[cont_i][cont_j].get_child(0).card.attributes
	if(cont_j>0):
		if(!FieldMatrix[cont_i][cont_j-1].Empty):
			left = FieldMatrix[cont_i][cont_j-1].get_child(0)
			if(left.OwnedbyPlayer == false):
				if(current_attributes["left"]>left.card.attributes["right"]):
					left.get_child(3).play("capture")
					left.OwnedbyPlayer = true
					aiTotalCard = aiTotalCard-1
					playerTotalCard = playerTotalCard +1
					iscapturing = true
	if(cont_j<2):
		if(!FieldMatrix[cont_i][cont_j+1].Empty):
			right = FieldMatrix[cont_i][cont_j+1].get_child(0)
			if(right.OwnedbyPlayer == false):
				if(current_attributes["right"]>right.card.attributes["left"]):
					right.get_child(3).play("capture")
					right.OwnedbyPlayer = true
					aiTotalCard = aiTotalCard-1
					playerTotalCard = playerTotalCard +1
					iscapturing = true
	if(cont_i>0):
		if(!FieldMatrix[cont_i-1][cont_j].Empty):
			top = FieldMatrix[cont_i-1][cont_j].get_child(0)
			if(top.OwnedbyPlayer == false):
				if(current_attributes["top"]>top.card.attributes["bottom"]):
					top.get_child(3).play("capture")
					top.OwnedbyPlayer = true
					aiTotalCard = aiTotalCard-1
					playerTotalCard = playerTotalCard +1
					iscapturing = true
	if(cont_i<2):
		if(!FieldMatrix[cont_i+1][cont_j].Empty):
			bottom = FieldMatrix[cont_i+1][cont_j].get_child(0)
			if(bottom.OwnedbyPlayer == false):
				if(current_attributes["bottom"]>bottom.card.attributes["top"]):
					bottom.get_child(3).play("capture")
					bottom.OwnedbyPlayer = true
					aiTotalCard = aiTotalCard-1
					playerTotalCard = playerTotalCard +1
					iscapturing = true
	if(iscapturing==true):
		$"/root/Global/Sounds/CaptureCard".play()
	$PlayerScores/Player2Score.update_score_texture(aiTotalCard)
	$PlayerScores/Player1Score.update_score_texture(playerTotalCard)

func aiCaptureCard():
	var top
	var left
	var right
	var bottom
	var iscapturing = false
	current_attributes = FieldMatrix[aii][aij].get_child(0).card.attributes
	if(aij>0):
		if(!FieldMatrix[aii][aij-1].Empty):
			left = FieldMatrix[aii][aij-1].get_child(0)
			if(left.OwnedbyPlayer == true):
				if(current_attributes["left"]>left.card.attributes["right"]):
					left.get_child(3).play("capture")
					left.OwnedbyPlayer = false
					aiTotalCard = aiTotalCard+1
					playerTotalCard = playerTotalCard -1
					iscapturing = true
	if(aij<2):
		if(!FieldMatrix[aii][aij+1].Empty):
			right = FieldMatrix[aii][aij+1].get_child(0)
			if(right.OwnedbyPlayer == true):
				if(current_attributes["right"]>right.card.attributes["left"]):
					right.get_child(3).play("capture")
					right.OwnedbyPlayer = false
					aiTotalCard = aiTotalCard+1
					playerTotalCard = playerTotalCard -1
					iscapturing = true
	if(aii>0):
		if(!FieldMatrix[aii-1][aij].Empty):
			top = FieldMatrix[aii-1][aij].get_child(0)
			if(top.OwnedbyPlayer == true):
				if(current_attributes["top"]>top.card.attributes["bottom"]):
					top.get_child(3).play("capture")
					top.OwnedbyPlayer = false
					aiTotalCard = aiTotalCard+1
					playerTotalCard = playerTotalCard -1
					iscapturing = true
	if(aii<2):
		if(!FieldMatrix[aii+1][aij].Empty):
			bottom = FieldMatrix[aii+1][aij].get_child(0)
			if(bottom.OwnedbyPlayer == true):
				if(current_attributes["bottom"]>bottom.card.attributes["top"]):
					bottom.get_child(3).play("capture")
					bottom.OwnedbyPlayer = false
					aiTotalCard = aiTotalCard+1
					playerTotalCard = playerTotalCard -1
					iscapturing = true
	if(iscapturing==true):
		$"/root/Global/Sounds/CaptureCard".play()
	$PlayerScores/Player2Score.update_score_texture(aiTotalCard)
	$PlayerScores/Player1Score.update_score_texture(playerTotalCard)




func game_end():
	$"/root/Global".Last_match = player_state
	if(player_state == "win"):
		$"/root/Global".win = $"/root/Global".win +1
	elif(player_state == "lose"):
		$"/root/Global".lose = $"/root/Global".lose +1
	elif(player_state == "draw"):
		$"/root/Global".draw = $"/root/Global".draw +1
	$"/root/Global".matches = $"/root/Global".matches +1
	get_tree().change_scene("res://Scenes/GameResult/GameEnd.tscn")

func after_anim(anim_name):
	ai_turn()
