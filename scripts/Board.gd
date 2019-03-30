extends TileMap

#const containing the board width and height
var board_width = 10
var board_height = 10
#bool true if game is over and player lost
var game_over = false
#2D matrix that represents the board, contains 1(mine) or 0(empty)
var board=[]

#function showing the game over screen
func game_over():
	game_over = true
	for i in get_tree().get_nodes_in_group("Control"):
		i.show()

func _ready():
	game_over = false
	board_width = global.width
	board_height = global.height
	#filling the board-matrix
	for i in range(-(board_width/2), board_width/2):
		board.append([])
		board[i+(board_width/2)] = []
		for j in range(-(board_height/2), board_height/2):
			#placing cells based on width&height of the board
			set_cell(i,j,0,false,false)
			#getting either 1 or 0 and putting them into the board-matrix
			randomize()
			var rand = randi()%2+0
			board[i+(board_width/2)].append([])
			board[i+(board_width/2)][j+(board_height/2)] = rand
			
func _input(event):
	#checking if player is clicking on a tile and the game is not over
	if event is InputEventMouseButton && !game_over:
		#getting the global position of the mouse click
		var event_pos = event.global_position
		#converting the global position to a map position for the TileMap
		var cell_pos = world_to_map(event_pos)
		#adjusting the cell position because it's always off,y is strange needs investigation
		cell_pos.x = cell_pos.x-16
		cell_pos.y = cell_pos.y-9.5
		#each cell has a corresponding value inside the matrix but you cant have a negative index
		var m_pos = cell_pos
		m_pos.x = cell_pos.x+(board_width/2)
		m_pos.y = cell_pos.y+(board_height/2)
		#checking if the click is inside the board
		if(m_pos.x < board_width \
		  && m_pos.y < board_height \
		  && cell_pos.x+board_width > board_width/2 \
		  && cell_pos.y+board_height > board_height/2):
			#checking if player left or right clicks
			if(event.is_action_pressed("p_click")):
				if(board[m_pos.x][m_pos.y] == 0):
					#player hit an empty tile
					#TODO: change the tile to the number of mines nearby
					set_cellv(cell_pos,4,false,false)
				else:
					#player hit a mine
					set_cellv(cell_pos,1,false,false)
					game_over()
			#player can only place flags if the game mode allows it
			if(event.is_action("p_flag") \
			  && global.allow_flags):
				set_cellv(cell_pos,2,false,false)