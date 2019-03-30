extends TileMap

#offset of the tile position when clicking (gay af)
const WIDTH_OFFSET = 16
const HEIGHT_OFFSET = 9.5

#int containing the board width and height
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

#function that returns the index of the tile based on the number of mines surrounding it
func tile_index(mines):
	var i = 3
	if(mines == 0):
		i = 3
	if(mines == 1):
		i = 4
	if(mines == 2):
		i = 5
	if(mines == 3):
		i = 6
	if(mines == 4):
		i = 7
	if(mines == 5):
		i = 8
	if(mines == 6):
		i = 9
	if(mines == 7):
		i = 10
	if(mines == 8):
		i = 11
	return i

#function that returns the number of mines surrounding the tile
#based on the positing in the board-matrix
func mines_nearby(m_pos):
	var mines = 0
	for x in range(m_pos.x-1,m_pos.x+1):
		if x>=0:
			for y in range(m_pos.y-1,m_pos.y+1):
				if y>= 0:
					if(board[x][y]==1):
						mines+=1
	return mines

#function that changes the tile based on the number of mines surrounding it
#takes the positing of the tile on the map
func change_tile(cell_pos):
	#changing the cell positing to the position in the board-matrix
	var m_pos = cell_pos
	m_pos.x = cell_pos.x+(board_width/2)
	m_pos.y = cell_pos.y+(board_height/2)
	#getting the number of mines surrounding the tile
	var mines = mines_nearby(m_pos)
	#changing the tile
	set_cellv(cell_pos,tile_index(mines),false,false)

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
		cell_pos.x = cell_pos.x-WIDTH_OFFSET
		cell_pos.y = cell_pos.y-HEIGHT_OFFSET
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
					set_cellv(cell_pos,4,false,false)
					change_tile(cell_pos)
				else:
					#player hit a mine
					set_cellv(cell_pos,1,false,false)
					game_over()
			#player can only place flags if the game mode allows it
			if(event.is_action("p_flag") \
			  && global.allow_flags):
				set_cellv(cell_pos,2,false,false)